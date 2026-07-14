#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

info() { echo "[install] $*"; }
warn() { echo "[install] WARNING: $*" >&2; }

# --- Package manager ---

if command -v apt-get &>/dev/null; then
  info "Updating apt..."
  sudo apt-get update -qq

  info "Installing packages..."
  sudo apt-get install -y -qq \
    stow \
    tmux \
    zsh \
    git \
    curl \
    unzip \
    ripgrep \
    fzf \
    exa \
    zoxide
else
  warn "apt not found -- skipping system packages. Install these manually:"
  warn "  stow tmux zsh git curl unzip ripgrep fzf exa zoxide"
fi

# --- Neovim (latest stable, not the ancient apt version) ---

if ! command -v nvim &>/dev/null; then
  info "Installing neovim..."
  curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    | sudo tar xz -C /usr/local --strip-components=1
fi

# --- Starship prompt ---

if ! command -v starship &>/dev/null; then
  info "Installing starship..."
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
fi

# --- GitHub CLI ---

if ! command -v gh &>/dev/null; then
  info "Installing GitHub CLI..."
  (type -p wget >/dev/null || sudo apt-get install -y -qq wget) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) \
    && wget -qO "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null \
    && sudo apt-get update -qq \
    && sudo apt-get install -y -qq gh \
    && rm -f "$out"
fi

# --- Lazygit ---

if ! command -v lazygit &>/dev/null; then
  info "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    | sudo tar xz -C /usr/local/bin lazygit
fi

# --- Oh My Zsh + plugins ---

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

declare -A zsh_plugins=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
  [zsh-vi-mode]="https://github.com/jeffreytse/zsh-vi-mode"
  [zlong_alert]="https://github.com/kevinywlui/zlong_alert.zsh"
)

for plugin in "${!zsh_plugins[@]}"; do
  if [[ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
    info "Installing zsh plugin: $plugin"
    git clone --depth 1 "${zsh_plugins[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

# --- Git submodules (TPM, etc.) ---

info "Initializing git submodules..."
git -C "$DOTFILES_DIR" submodule update --init --recursive

# --- Stow all packages ---

info "Stowing dotfiles..."
"$DOTFILES_DIR/bin/dotfiles" stow

info "Done. Open tmux and press prefix + I to install tmux plugins."
