import base64
import os
from pathlib import Path
import socket
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class DotfilesHelperTest(unittest.TestCase):
    def test_linux_default_stow_skips_claude_and_mac_git_without_adopting_files(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            home = root / "home"
            bin_dir = root / "bin"
            log = root / "stow.log"
            home.mkdir()
            bin_dir.mkdir()
            stow = bin_dir / "stow"
            stow.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$STOW_LOG"\n')
            stow.chmod(0o755)
            uname = bin_dir / "uname"
            uname.write_text("#!/bin/sh\necho Linux\n")
            uname.chmod(0o755)
            env = os.environ.copy()
            env.update(HOME=str(home), PATH=f"{bin_dir}:/usr/bin:/bin", STOW_LOG=str(log))

            result = subprocess.run(
                [ROOT / "bin/dotfiles", "stow"],
                capture_output=True,
                text=True,
                check=True,
                env=env,
            )
            calls = log.read_text().splitlines()

            self.assertGreater(len(calls), 0)
            self.assertTrue(all("claude" not in call for call in calls))
            self.assertTrue(all("git " not in call for call in calls))
            self.assertTrue(any("git-linux" in call for call in calls))
            self.assertTrue(all("--adopt" not in call for call in calls))
            self.assertEqual(result.stdout.count("stowed "), len(calls))

    def test_linux_rerun_preserves_workspaces_managed_gitconfig(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            home = root / "home"
            bin_dir = root / "bin"
            log = root / "stow.log"
            home.mkdir()
            bin_dir.mkdir()
            (home / ".gitconfig").write_text("# Managed by workspaces\n[core]\n\thooksPath = managed\n")
            (bin_dir / "stow").write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$STOW_LOG"\n')
            (bin_dir / "stow").chmod(0o755)
            (bin_dir / "uname").write_text("#!/bin/sh\necho Linux\n")
            (bin_dir / "uname").chmod(0o755)
            env = os.environ.copy()
            env.update(HOME=str(home), PATH=f"{bin_dir}:/usr/bin:/bin", STOW_LOG=str(log))

            subprocess.run(
                [ROOT / "bin/dotfiles", "stow"],
                capture_output=True,
                text=True,
                check=True,
                env=env,
            )

            calls = log.read_text().splitlines()
            self.assertTrue(all("git-linux" not in call for call in calls))
            self.assertTrue(all(" git " not in call for call in calls))
            self.assertTrue((home / ".gitconfig").is_file())
            self.assertFalse((home / ".gitconfig").is_symlink())

    def test_linux_preserves_the_known_workspace_zsh_template(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            home = root / "home"
            bin_dir = root / "bin"
            log = root / "stow.log"
            home.mkdir()
            bin_dir.mkdir()
            template = (
                "# If you come from bash you might have to change your $PATH.\n"
                'ZSH_THEME="robbyrussell"\n'
            )
            (home / ".zshrc").write_text(template)
            (bin_dir / "stow").write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$STOW_LOG"\n')
            (bin_dir / "stow").chmod(0o755)
            (bin_dir / "uname").write_text("#!/bin/sh\necho Linux\n")
            (bin_dir / "uname").chmod(0o755)
            env = os.environ.copy()
            env.update(HOME=str(home), PATH=f"{bin_dir}:/usr/bin:/bin", STOW_LOG=str(log))

            result = subprocess.run(
                [ROOT / "bin/dotfiles", "stow", "zsh"],
                capture_output=True,
                text=True,
                check=True,
                env=env,
            )

            self.assertFalse((home / ".zshrc").exists())
            self.assertEqual((home / ".zshrc.workspace-default").read_text(), template)
            self.assertIn("preserved workspace default", result.stdout)
            self.assertIn("zsh", log.read_text())

    def test_linux_refuses_an_unmanaged_zshrc(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            home = root / "home"
            bin_dir = root / "bin"
            home.mkdir()
            bin_dir.mkdir()
            (home / ".zshrc").write_text("user configuration\n")
            (bin_dir / "stow").write_text("#!/bin/sh\nexit 0\n")
            (bin_dir / "stow").chmod(0o755)
            (bin_dir / "uname").write_text("#!/bin/sh\necho Linux\n")
            (bin_dir / "uname").chmod(0o755)
            env = os.environ.copy()
            env.update(HOME=str(home), PATH=f"{bin_dir}:/usr/bin:/bin")

            result = subprocess.run(
                [ROOT / "bin/dotfiles", "stow", "zsh"],
                capture_output=True,
                text=True,
                env=env,
            )

            self.assertNotEqual(result.returncode, 0)
            self.assertIn("refusing to replace unmanaged", result.stderr)
            self.assertEqual((home / ".zshrc").read_text(), "user configuration\n")

    def test_stow_failure_is_not_reported_as_success(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            home = root / "home"
            bin_dir = root / "bin"
            home.mkdir()
            bin_dir.mkdir()
            (bin_dir / "stow").write_text("#!/bin/sh\nexit 1\n")
            (bin_dir / "stow").chmod(0o755)
            (bin_dir / "uname").write_text("#!/bin/sh\necho Darwin\n")
            (bin_dir / "uname").chmod(0o755)
            env = os.environ.copy()
            env.update(HOME=str(home), PATH=f"{bin_dir}:/usr/bin:/bin")

            result = subprocess.run(
                [ROOT / "bin/dotfiles", "stow", "alacritty"],
                capture_output=True,
                text=True,
                env=env,
            )

            self.assertNotEqual(result.returncode, 0)
            self.assertNotIn("stowed alacritty", result.stdout)


class WorkspaceDevTest(unittest.TestCase):
    def test_create_derives_workspace_and_uses_required_flags(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo = root / "sample"
            bin_dir = root / "bin"
            log = root / "commands.log"
            bin_dir.mkdir()
            repo.mkdir()
            subprocess.run(["git", "init", "--quiet", "--initial-branch", "feature"], cwd=repo, check=True)
            subprocess.run(
                ["git", "remote", "add", "origin", "git@ddoghq.github.com:ddoghq-sandbox/sample.git"],
                cwd=repo,
                check=True,
            )
            (bin_dir / "workspaces").write_text(
                "#!/bin/sh\n"
                "printf 'workspaces %s cwd=%s\\n' \"$*\" \"$PWD\" >> \"$COMMAND_LOG\"\n"
                "if [ \"$1\" = list ]; then printf 'NAME\\n'; fi\n"
            )
            (bin_dir / "ssh-add").write_text("#!/bin/sh\nexit 0\n")
            (bin_dir / "ssh").write_text(
                "#!/bin/sh\n"
                "if [ \"$1\" = -G ]; then echo 'forwardagent yes'; exit 0; fi\n"
                "printf 'ssh %s\\n' \"$*\" >> \"$COMMAND_LOG\"\n"
            )
            for command in ("workspaces", "ssh-add", "ssh"):
                (bin_dir / command).chmod(0o755)

            agent = socket.socket(socket.AF_UNIX)
            agent_path = str(root / "agent.sock")
            agent.bind(agent_path)
            try:
                env = os.environ.copy()
                env.update(
                    PATH=f"{bin_dir}:/usr/bin:/bin",
                    COMMAND_LOG=str(log),
                    SSH_AUTH_SOCK=agent_path,
                )
                subprocess.run(
                    [ROOT / "home/local/.local/bin/workspace-dev", "create", repo],
                    check=True,
                    capture_output=True,
                    text=True,
                    env=env,
                )
            finally:
                agent.close()

            commands = log.read_text()
            self.assertIn(
                "workspaces create sample-x86 --instance-type aws:m5d.4xlarge --region us-east-1 --shell zsh --yes cwd=",
                commands,
            )
            create_line = next(line for line in commands.splitlines() if "workspaces create" in line)
            self.assertNotIn("--repo", create_line)
            self.assertNotIn(f"cwd={repo}", create_line)
            self.assertIn("workspaces ssh-config sample-x86", commands)
            self.assertIn("workspaces dotfiles sync sample-x86", commands)
            repository = base64.b64encode(b"ddoghq-sandbox/sample").decode()
            branch = base64.b64encode(b"feature").decode()
            self.assertIn(
                f"ssh -o BatchMode=yes workspace-sample-x86 bash -s -- {repository} {branch}",
                commands,
            )

    def test_create_rejects_an_already_listed_name(self):
        script = (ROOT / "home/local/.local/bin/workspace-dev").read_text()
        self.assertIn("workspace is already listed", script)
        self.assertIn("workspaces list --no-color", script)

    def test_finalization_uses_workspace_identity_for_pi_and_git(self):
        script = (ROOT / "home/local/.local/bin/workspace-dev").read_text()
        self.assertIn("ddtool auth login --mode auth-code --datacenter us1.ddbuild.io", script)
        self.assertIn("/refresh-models preset terminal-bench-2.0-top10", script)
        self.assertIn("git config --global --includes --get user.name", script)
        self.assertNotIn("--api-key", script)


class TmuxStateTest(unittest.TestCase):
    def test_downloaded_plugins_stay_outside_the_repository(self):
        config = (ROOT / "home/tmux/.tmux.conf").read_text()
        self.assertIn(
            "set-environment -g TMUX_PLUGIN_MANAGER_PATH '~/.local/share/tmux/plugins/'",
            config,
        )
        self.assertIn("run '~/.tmux/plugins/tpm/tpm'", config)


class VimStateTest(unittest.TestCase):
    def test_mutable_state_stays_outside_the_repository(self):
        vimrc = (ROOT / "home/vim/.vimrc").read_text()

        self.assertIn("set packpath^=~/.local/share/vim", vimrc)
        self.assertIn("set directory^=~/.local/state/vim/swap//", vimrc)
        self.assertIn("set backupdir^=~/.local/state/vim/backup//", vimrc)
        self.assertIn("set undodir=~/.local/state/vim/undo", vimrc)
        self.assertNotIn("set undodir=~/.vim/undo", vimrc)


if __name__ == "__main__":
    unittest.main()
