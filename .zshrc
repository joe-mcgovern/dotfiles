# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="spaceship"

# ORDER
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
    # Activates the ZSH completion plugin shipped together with the aws command-line tool
    aws

    # Install completions for asdf version manager
    asdf

    # Auto complete arguments and options for all docker commands.
    docker

    # Enables the zsh completion from git.git folks, which is much faster
    # than the official one from zsh. A lot of zsh-specific features are not
    # supported, like descriptions for every argument, but everything the
    # bash completion has, this one does too (as it is using it behind the
    # scenes). Not only is it faster, it should be more robust, and updated
    # regularly to the latest git upstream version.
    gitfast

    # Provides auto-completion for helm
    helm

    # Auto-completions for the pass password manager
    pass

    # Completion plugin for the pip command
    pip

    # Completion for the python interpreter
    python

    # Adds several options for effecting the startup behavior of tmux
    # tmux

    # Completions for tmuxinator
    # tmuxinator

    # Suggests commands as you type, based on command history
    zsh-autosuggestions

    # This package provides syntax highlighting for the shell zsh.
    # It enables highlighting of commands whilst they are typed at a zsh
    # prompt into an interactive terminal. This helps in reviewing commands
    # before running them, particularly in catching syntax errors
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Add /usr/local/bin to path
export PATH=/usr/local/bin/:$PATH

# Add globally installed npm packages to path
export PATH="$HOME/.npm-packages/bin:$PATH"

# Go environment configuration
export GOPATH=$HOME/go-workspace
export GOROOT=/usr/local/go
export GO111MODULE=on
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Python environment configuration
export PYTHONPATH=/usr/bin/python
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export WORKON_HOME=$HOME/Envs
source /usr/local/bin/virtualenvwrapper.sh
# Tell pyenv-virtualenvwrapper to use pyenv when creating new Python environments
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

# Talisman environment configuration
export TALISMAN_HOME=/Users/josephmcgovern/.talisman/bin

# Set the length of generated passwords for pass library
export PASSWORD_STORE_GENERATED_LENGTH=42

# Setup python virtualenv home

DEFAULT_USER=“josephmcgovern”

##########
# Normal Alias Shortcuts
##########
alias awsk="pbpaste > ~/.aws/credentials"
alias wbuild="/usr/local/bin/workiva-build-cli"
alias gif="~/local_scripts/.giffify.sh"
alias talisman=$TALISMAN_HOME/talisman_darwin_amd64
alias k="kubectl"

# Define encrypt function that will AES 256 encrypt a file
encrypt(){
    outfile="$@.enc"
    openssl enc -aes-256-cbc -salt -in "$@" -out $outfile
    echo "Encrypted: $outfile"
}

# Set default editor to nvim
export EDITOR="/usr/local/bin/nvim"

# Set default shell to zsh
export SHELL="/bin/zsh"

# Use rg instead of fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Add w-secrets to environment
if [ -f ~/.w_secrets.sh ]; then
    source ~/.w_secrets.sh
fi

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


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/josephmcgovern/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/josephmcgovern/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/josephmcgovern/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/josephmcgovern/google-cloud-sdk/completion.zsh.inc'; fi

# Define the language & locale
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF8"

# Define rpg (a function that behaves like cd)
RPG_CLI=/usr/local/bin/rpg
rpg () {
   $RPG_CLI "$@"
   cd "$($RPG_CLI --pwd)"
}

# Initialize wk tool
source ~/.wk/profile

# Configure pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Initialize starship theme
eval "$(starship init zsh)"
