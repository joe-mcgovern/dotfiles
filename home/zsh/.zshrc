# ----- Path manipulation -----
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Add brew to path
export PATH="/opt/homebrew/bin:$PATH"

# Add rubies to path
export PATH="$HOME/.rubies:$PATH"

# Add poetry to path
export PATH="$HOME/.poetry/bin:$PATH"

# Add pipx (and other things in .local/bin) to path
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Add globally installed npm binaries to path
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Add go binaries to path
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# ----- Plugins ---------------------------------------------------------------
# Reduced plugin set for faster startup
plugins=(
    git
    zlong_alert
    zsh-vi-mode
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# For bazel configuration
fpath[1,0]=~/.zsh/completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Autoload completion (with cache check for speed)
autoload -Uz compinit
# Check if .zcompdump needs updating (only once per day)
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Initialize oh-my-zsh
source $ZSH/oh-my-zsh.sh

# ----- Enviroment variable configuration -------------------------------------

# When virtualenvwrapper will store virtual environment configurations
export WORKON_HOME="$HOME/.envs"
export VIRTUALENVWRAPPER_PYTHON="$HOME/.pyenv/shims/python"

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# ----- emoji-fzf configuration -----------------------------------------------
EMOJI_FZF_BIN_PATH="$HOME/.local/bin/emoji-fzf"
EMOJI_FZF_BINDKEY="^e"
EMOJI_FZF_FUZZY_FINDER="fzf"

# ----- zlong configuration -----------------------------------------------
zlong_duration=10
zlong_ignore_cmds="vim ssh less git k9s kubectl k"

# ----- ZVM configuration -----------------------------------------------------
# Use `jk` to go from insert to normal mode
ZVM_VI_INSERT_ESCAPE_BINDKEY="jk"
# Use "nex" readkey engine, which is supposedly better than zle (default)
ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX
# Always starting with insert mode for each command line
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# ----- Aliases ---------------------------------------------------------------

alias g="git"
alias gc='git commit -m'
alias gs='git status'
alias ga='git add'
alias gn='git new'
alias gr='git restore'
alias gco='git co'
alias lg="lazygit"
alias ls="exa --no-user --long --no-permissions --icons --header --no-time"
alias tf='terraform'
alias k="kubectl"
# This sets the default namesapce. Use this like `kn <namespace>`
alias kn="kubectl config set-context --current --namespace"

# ----- Various tool initializations ------------------------------------------

# Use ripgrep instead of fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
# I got off git because this doesnt work well when adding/removing files within
# the work tree that haven't yet been staged.
# export FZF_DEFAULT_COMMAND='git ls-files 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Initialize starship prompt (lazy load for speed)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

[ -f ~/fzf.zsh ] && source ~/fzf.zsh

# Local initializations that shouldn't be pushed to an open-source repository!
[ -f ~/local.zsh ] && source ~/local.zsh

# Define an init function and append to zvm_after_init_commands
function my_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  [ -f /usr/local/bin/fzf-git-functions.sh ] && source /usr/local/bin/fzf-git-functions.sh
  autoload -U up-line-or-beginning-search
  autoload -U down-line-or-beginning-search
  zle -N up-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "^[[A" up-line-or-beginning-search # Up
  bindkey "^[[B" down-line-or-beginning-search # Down
}
zvm_after_init_commands+=(my_init)

# google-cloud-sdk brew caveat (conditional loading)
[ -f "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ] && source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
[ -f "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ] && source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.volta/bin:$PATH"


# Enable brew autocompletion (avoid duplicate compinit)
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Initialize zoxide (lazy load for speed)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

export GH_DASH_CONFIG=$HOME/gh-dash/config.yaml

alias gsti="~/dev/fzf-git.sh"

# BEGIN CLAUDE TRAJECTORY MANAGED BLOCK
export PATH="/Users/joe.mcgovern/.datadog/bin:$PATH"
# END CLAUDE TRAJECTORY MANAGED BLOCK
