# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="simple"

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
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/bin:/bin:/usr/sbin:/sbin:/...
export PATH="$HOME/.npm-packages/bin:$PATH"
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=$HOME/Library/Python/2.7/bin:$PATH
export ANDROID_HOME=/usr/local/Cellar/android-sdk/24.4.1_1/
export JAVA_HOME=/Library/Java/Home
export WORKON_HOME=~/Envs
source /usr/local/bin/virtualenvwrapper.sh

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
alias test='python run_nosetests.py'
alias aws_keys='~/get_aws_keys.sh'
alias tmux='tmux -2'
alias tmux_gae='~/tmux_gae.sh'
alias ctags="`brew --prefix`/bin/ctags"

##########
# Adding Git Shortcuts
##########
alias gcob='git checkout -b'
alias gcim='git commit -m'
alias gs='git status'
alias gls="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias jupyter="/usr/local/bin/jupyter-notebook"

export PATH=/usr/local/bin:$PATH
export PYTHONPATH=/usr/bin/python
export GITHUB_TOKEN=5df328574d48ee50c015b4e1337f3c36d9e646a9

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/josephmcgovern/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/josephmcgovern/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/josephmcgovern/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/josephmcgovern/google-cloud-sdk/completion.zsh.inc'; fi
