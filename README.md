# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). There's a helper
script at `bin/dotfiles` that wraps the common operations.

## Track a new config

```sh
./bin/dotfiles add ~/.config/foo
```

This moves the file/directory into the repo and symlinks it back. Done.

It works for anything under `$HOME`:

```sh
./bin/dotfiles add ~/.config/nvim       # whole directory
./bin/dotfiles add ~/.config/foo/bar.toml  # single file
./bin/dotfiles add ~/.somerc            # dotfile in $HOME
```

## Linux workspace setup

For provisioning apt-based x86_64 Linux workspaces:

```sh
git clone --recursive <repo-url> ~/dev/dotfiles
cd ~/dev/dotfiles
./install.sh
```

The installer fails if requested setup cannot complete. It installs the base
shell and editor tools, Volta-managed Node `24.18.0`, Bun, Pi `0.80.6`, and
TPM-managed tmux plugins before stowing the portable Linux configuration. The
macOS-specific `git` package is deliberately not stowed on Linux; the
`git-linux` package supplies aliases and settings without an identity, signing
configuration, credential helper, or machine-specific paths.

## Workspace workflow

After dotfiles have been installed, `~/.local/bin/workspace-dev` creates and
finalizes generic x86 workspaces:

```sh
workspace-dev create ~/src/owner/repository
workspace-dev sync repository-x86 [~/src/owner/repository]
workspace-dev verify repository-x86
```

`create` derives the repository and current branch from the checkout's GitHub
`origin`, creates `repository-x86` with `aws:m5d.4xlarge` in `us-east-1`, and
uses zsh. It refuses a name already shown by `workspaces list`. Both `create`
and `sync` require an SSH agent with an identity and verify that the generated
`workspace-<name>` alias enables agent forwarding. The remote finalization
clones or fast-forwards `pi-config` and `datadog-pi-packages` using
credential-free SSH remotes, then reruns the dotfiles and Pi installers. Pass a
repository path to `sync` when recovering a workspace that was provisioned but
had not yet recorded its primary repository metadata.

`verify` checks the architecture, required tools, Docker Compose, both
checkouts and remotes, Pi-managed links, and a configured Git identity. The
installer can perform public provisioning before a forwarded agent is
available, but private repository finalization is intentionally deferred until
`create` or `sync` has forwarded authentication.

## macOS setup

```sh
brew install stow
git clone --recursive <repo-url> ~/dev/dotfiles
cd ~/dev/dotfiles
./bin/dotfiles stow          # symlink all configs into $HOME
./bin/dotfiles stow nvim git # or just specific ones
```

Install other tools with `brew` as needed (tmux, neovim, starship, fzf, etc.).

## Agent configuration

Pi and shared coding-agent configuration are managed separately in a private
`~/dev/pi-config` repository. Agent credentials and runtime state are never
stored here.

## Other commands

```sh
./bin/dotfiles list            # show all packages
./bin/dotfiles unstow <pkg>    # remove symlinks for a package
```

## Sensitive files

Files with secrets are excluded via `.gitignore`. If you add a config that
contains credentials, add it to `.gitignore` before committing.
