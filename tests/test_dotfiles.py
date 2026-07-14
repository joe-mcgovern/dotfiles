import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class DotfilesHelperTest(unittest.TestCase):
    def test_default_stow_skips_claude_without_adopting_files(self):
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
            self.assertTrue(all("--adopt" not in call for call in calls))
            self.assertEqual(result.stdout.count("stowed "), len(calls))


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
