#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

info() { echo "[install] $*"; }
die() { echo "[install] error: $*" >&2; exit 1; }

install_linux_packages() {
  info "Updating apt..."
  sudo apt-get update -qq

  info "Installing base packages..."
  sudo apt-get install -y -qq \
    bc \
    ca-certificates \
    curl \
    fzf \
    git \
    gnupg \
    openssh-client \
    ripgrep \
    stow \
    tmux \
    unzip \
    wget \
    zoxide \
    zsh
}

install_neovim() {
  if command -v nvim >/dev/null 2>&1; then
    return
  fi

  info "Installing neovim..."
  curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    | sudo tar xz -C /usr/local --strip-components=1
  command -v nvim >/dev/null 2>&1 || die "neovim installation did not provide nvim"
}

install_starship() {
  if command -v starship >/dev/null 2>&1; then
    return
  fi

  info "Installing starship..."
  local installer
  installer="$(mktemp)"
  trap 'rm -f "$installer"' RETURN
  curl -fsSL https://starship.rs/install.sh -o "$installer"
  sh "$installer" -y -b "$HOME/.local/bin"
  rm -f "$installer"
  trap - RETURN
  command -v starship >/dev/null 2>&1 || die "starship installation did not provide starship"
}

install_github_cli() {
  if command -v gh >/dev/null 2>&1; then
    return
  fi

  info "Installing GitHub CLI..."
  local keyring temporary
  keyring=/etc/apt/keyrings/githubcli-archive-keyring.gpg
  temporary="$(mktemp)"
  trap 'rm -f "$temporary"' RETURN
  sudo install -d -m 755 /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o "$temporary"
  sudo install -m 644 "$temporary" "$keyring"
  printf 'deb [arch=%s signed-by=%s] https://cli.github.com/packages stable main\n' \
    "$(dpkg --print-architecture)" "$keyring" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update -qq
  sudo apt-get install -y -qq gh
  rm -f "$temporary"
  trap - RETURN
  command -v gh >/dev/null 2>&1 || die "GitHub CLI installation did not provide gh"
}

install_lazygit() {
  if command -v lazygit >/dev/null 2>&1; then
    return
  fi

  info "Installing lazygit..."
  local version archive
  version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | sed -nE 's/.*"tag_name": "v([^"]+)".*/\1/p')"
  [[ -n "$version" ]] || die "could not determine lazygit version"
  archive="$(mktemp)"
  trap 'rm -f "$archive"' RETURN
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz" -o "$archive"
  mkdir -p "$HOME/.local/bin"
  tar xzf "$archive" -C "$HOME/.local/bin" lazygit
  rm -f "$archive"
  trap - RETURN
  command -v lazygit >/dev/null 2>&1 || die "lazygit installation did not provide lazygit"
}

install_volta_node_and_pi() {
  export VOLTA_HOME="${VOLTA_HOME:-$HOME/.volta}"
  export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
  export PATH="$BUN_INSTALL/bin:$VOLTA_HOME/bin:$HOME/.local/bin:$PATH"

  if ! command -v volta >/dev/null 2>&1; then
    info "Installing Volta..."
    local installer
    installer="$(mktemp)"
    trap 'rm -f "$installer"' RETURN
    curl -fsSL https://get.volta.sh -o "$installer"
    bash "$installer"
    rm -f "$installer"
    trap - RETURN
  fi
  command -v volta >/dev/null 2>&1 || die "Volta installation did not provide volta"

  info "Installing Node 24.18.0 with Volta..."
  volta install node@24.18.0
  [[ "$(node --version)" == "v24.18.0" ]] || die "expected Node v24.18.0, found $(node --version)"

  if ! command -v bun >/dev/null 2>&1; then
    info "Installing Bun..."
    local installer
    installer="$(mktemp)"
    trap 'rm -f "$installer"' RETURN
    curl -fsSL https://bun.sh/install -o "$installer"
    bash "$installer"
    rm -f "$installer"
    trap - RETURN
    export PATH="${BUN_INSTALL:-$HOME/.bun}/bin:$PATH"
  fi
  command -v bun >/dev/null 2>&1 || die "Bun installation did not provide bun"

  info "Installing Pi 0.80.6 and OpenSpec 1.6.0..."
  npm install -g \
    @earendil-works/pi-coding-agent@0.80.6 \
    @fission-ai/openspec@1.6.0
  command -v pi >/dev/null 2>&1 || die "Pi installation did not provide pi"
  [[ "$(openspec --version)" == "1.6.0" ]] || die "OpenSpec installation did not provide version 1.6.0"
}

install_zsh_plugins() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "Installing oh-my-zsh..."
    local installer had_zshrc=false
    [[ -e "$HOME/.zshrc" || -L "$HOME/.zshrc" ]] && had_zshrc=true
    installer="$(mktemp)"
    trap 'rm -f "$installer"' RETURN
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o "$installer"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh "$installer" --unattended
    if [[ "$had_zshrc" == false && -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
      rm "$HOME/.zshrc"
    fi
    rm -f "$installer"
    trap - RETURN
  fi

  local zsh_custom
  zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  declare -A zsh_plugins=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
    [zsh-vi-mode]="https://github.com/jeffreytse/zsh-vi-mode"
    [zlong_alert]="https://github.com/kevinywlui/zlong_alert.zsh"
  )

  local plugin
  for plugin in "${!zsh_plugins[@]}"; do
    if [[ ! -d "$zsh_custom/plugins/$plugin" ]]; then
      info "Installing zsh plugin: $plugin"
      git clone --depth 1 "${zsh_plugins[$plugin]}" "$zsh_custom/plugins/$plugin"
    fi
  done
}

install_tpm_plugins() {
  local tpm="$HOME/.tmux/plugins/tpm"
  [[ -x "$tpm/bin/install_plugins" ]] || die "TPM install script was not stowed"
  info "Installing tmux plugins..."
  "$tpm/bin/install_plugins"
}

mkdir -p "$HOME/.local/bin"

case "$(uname -s):$(uname -m)" in
  Linux:x86_64)
    command -v apt-get >/dev/null 2>&1 || die "apt-get is required on Linux x86_64"
    install_linux_packages
    export PATH="$HOME/.local/bin:$PATH"
    install_neovim
    install_starship
    install_github_cli
    install_lazygit
    install_volta_node_and_pi
    install_zsh_plugins
    ;;
  Darwin:*)
    info "macOS detected; using existing package-managed tools"
    command -v stow >/dev/null 2>&1 || die "stow is required; install it with Homebrew"
    ;;
  *)
    die "unsupported platform: $(uname -s) $(uname -m)"
    ;;
esac

info "Initializing git submodules..."
git -C "$DOTFILES_DIR" submodule update --init --recursive

info "Stowing dotfiles..."
"$DOTFILES_DIR/bin/dotfiles" stow

if [[ "$(uname -s)" == Linux ]]; then
  install_tpm_plugins
fi

info "Done."
