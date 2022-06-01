# Stowable packages

This directory contains stowable packages. Using stow allows them to be added
piecemeal.

Dotfiles can be prefixed with `dot-` instead of `.` so that they aren't hidden
by default. The `--dotfiles` flag in stow automatically converts them to the `.`
prefix when installing them.

To add one of these packages, run:
`stow --dotfiles -t "$HOME" <package name>`

where `<package name>` is something like `vim` or `git`
