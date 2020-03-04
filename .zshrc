# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="spaceship"

SPACESHIP_PROMPT_ORDER=(
venv
dir
git
line_sep
char
)

SPACESHIP_PROMPT_ADD_NEWLINE="true"
SPACESHIP_CHAR_SYMBOL=" \uf0e7"
SPACESHIP_CHAR_PREFIX="\uf296"
SPACESHIP_CHAR_SUFFIX=(" ")
SPACESHIP_PROMPT_DEFAULT_PREFIX="$USER"
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="true"
SPACESHIP_USER_SHOW="false"
SPACESHIP_HOST_SHOW="false"
SPACESHIP_PACKAGE_SHOW="false"
SPACESHIP_NODE_SHOW="false"
SPACESHIP_RUBY_SHOW="false"
SPACESHIP_VENV_PREFIX="("
SPACESHIP_VENV_SUFFIX=") "
SPACESHIP_VENV_COLOR="white"
SPACESHIP_KUBECONTEXT_SHOW="false"
SPACESHIP_PYENV_SHOW="false"

SPACESHIP_ROOT=$ZSH_CUSTOM/themes/spaceship-prompt

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

    # Auto complete arguments and options for all docker commands.
    docker

    # Enables the zsh completion from git.git folks, which is much faster
    # than the official one from zsh. A lot of zsh-specific features are not
    # supported, like descriptions for every argument, but everything the
    # bash completion has, this one does too (as it is using it behind the
    # scenes). Not only is it faster, it should be more robust, and updated
    # regularly to the latest git upstream version.
    gitfast

    # Provides a couple of convenient aliases for using the history command
    # to examine your command line history.
    history

    # Open jira issues
    # Example: jira TICKET-1234
    jira

    # Completion plugin for the pip command
    pip

    # Completion for the python interpreter
    python

    # Adds several options for effecting the startup behavior of tmux
    tmux

    # Completions for tmuxinator
    tmuxinator

    # Adds several commands to do web search.
    # Example: google some thing i want to find on google
    web-search

    # Suggests commands as you type, based on command history
    zsh-autosuggestions

    # This package provides syntax highlighting for the shell zsh.
    # It enables highlighting of commands whilst they are typed at a zsh
    # prompt into an interactive terminal. This helps in reviewing commands
    # before running them, particularly in catching syntax errors
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export ZSH_TMUX_AUTOSTART=true

# Customize to your needs...
export PATH=$PATH:~/.bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/bin:/bin:/usr/sbin:/sbin:/...
export PATH="$HOME/.npm-packages/bin:$PATH"
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=$HOME/Library/Python/2.7/bin:$PATH
export GOPATH=$HOME/go-workspace
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export ANDROID_HOME=/usr/local/Cellar/android-sdk/24.4.1_1/
export JAVA_HOME=/Library/Java/Home

export PYENV_ROOT="${HOME}/.pyenv"

if [ -d "${PYENV_ROOT}" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
fi

# Setup virtualenv home
export WORKON_HOME=$HOME/Envs
source /usr/local/bin/virtualenvwrapper.sh

# Tell pyenv-virtualenvwrapper to use pyenv when creating new Python environments
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

DEFAULT_USER=“josephmcgovern”

##########
# Normal Alias Shortcuts
##########
alias lla='ls -la'
alias la='ls -a'
alias ls='ls -GF'
alias lsa='ls -a -GF'
alias lsla='ls -lah -GF'
alias lsl='ls -lh -GF'
alias pw='pwd'
alias ch='cd ~'
alias cu='cd ..'
alias 'cd-'='cd -'
alias ls='ls -GF'
alias aws_keys='~/local_scripts/get_aws_keys.sh'
alias tmux='tmux -2'
alias tmux_gae='~/local_scripts/tmux_gae.sh'
# alias ctags="`brew --prefix`/bin/ctags"
alias wbuild="/Users/josephmcgovern/.cargo/bin/workiva-build-cli"
alias mux="tmuxinator"
alias cover="open cover/index.html"
alias gif="~/local_scripts/.giffify.sh"
alias test='TEST_FLAG=true python run_nosetests.py'
alias open-builds='~/wDev/open_builds/target/release/open_builds'
alias open-tests='~/wDev/open_tests/target/release/open_tests'

export PATH=/usr/local/bin:$PATH
export PYTHONPATH=/usr/bin/python

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

###-tns-completion-start-###
if [ -f /Users/josephmcgovern/.tnsrc ]; then
    source /Users/josephmcgovern/.tnsrc
fi
###-tns-completion-end-###

###-tns-completion-start-###
if [ -f /Users/josephmcgovern/.tnsrc ]; then
    source /Users/josephmcgovern/.tnsrc
fi
###-tns-completion-end-###

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(direnv hook zsh)"

# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
#
export EDITOR="/usr/local/bin/nvim"
export SHELL="/bin/zsh"

source ~/.bin/tmuxinator.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/josephmcgovern/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/josephmcgovern/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/josephmcgovern/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/josephmcgovern/google-cloud-sdk/completion.zsh.inc'; fi

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

source $(dirname $(gem which colorls))/tab_complete.sh
# alias ls='colorls --light --sort-dirs'
# alias lc='colorls --tree --light'

if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

export PATH=$PATH:/opt/apache-maven/bin

# Configure talisman. Talisman checks for secrets being committed in git
# repositories
export TALISMAN_HOME=/Users/josephmcgovern/.talisman/bin
alias talisman=$TALISMAN_HOME/talisman_darwin_amd64

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
