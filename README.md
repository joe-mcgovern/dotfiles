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

## New machine setup

```sh
brew install stow
git clone <repo-url> ~/dev/dotfiles
cd ~/dev/dotfiles
./bin/dotfiles stow          # symlink all configs into $HOME
./bin/dotfiles stow nvim git # or just specific ones
```

## Other commands

```sh
./bin/dotfiles list            # show all packages
./bin/dotfiles unstow <pkg>    # remove symlinks for a package
```

## Sensitive files

Files with secrets are excluded via `.gitignore`. If you add a config that
contains credentials, add it to `.gitignore` before committing.
