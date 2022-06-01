# ----- Path manipulation -----
# Path to your oh-my-zsh installation.
export ZSH="/Users/joemcgovern/.oh-my-zsh"

# Add poetry to path
export PATH="$HOME/.poetry/bin:$PATH"

# Add pipx (and other things in .local/bin) to path
export PATH="$HOME/.local/bin:$PATH"

# Add python3.9 site packages to pythonpath so vim can find globally installed
# python packages
export PYTHONPATH="$HOME/.local/lib/python3.9/site-packages:$PYTHONPATH"
export PYTHONPATH="$HOME/.local/lib/python3.10/site-packages:$PYTHONPATH"


# ----- Plugins ---------------------------------------------------------------
plugins=(
    asdf
    git
    gitfast
    pass
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Initialize oh-my-zsh
source $ZSH/oh-my-zsh.sh

# ----- Enviroment variable configuration -------------------------------------


# When virtualenvwrapper will store virtual environment configurations
export WORKON_HOME=~/.envs
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

# ----- Aliases ---------------------------------------------------------------

export DOCKER_IMAGES_TO_PRESERVE="searx/searx"

container_ids() {
  cmd="docker ps"
  if [ -n "$1" ]; then
    cmd="$cmd $1"
  fi
  eval $cmd | awk 'NR != 1 && index($2, "'$DOCKER_IMAGES_TO_PRESERVE'") == 0 {print $1}'
}

alias dka='docker kill $(container_ids)'
alias dca='docker rm $(container_ids -a)'

# FZF aliases with git. I got these from here:
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236#file-functions-sh-L41
source /usr/local/bin/fzf-git-functions.sh
alias gc='git commit -m'
alias gb='git checkout $(_gb)'
alias gs='_gf'
# alias gs='gs_file=$(_gf) && [ -n "$gs_file" ] && vim $gs_file'
alias ga='git add'
alias gl='git show $(_gh)'
alias gn='git new'
alias gr='git restore'
alias gco='git co'
alias lg="lazygit"
alias ls="exa --no-user --long --no-permissions --icons --header --no-time"
alias tf='terraform'


# SMARTLY open vim! This will open vim using pipenv run vim or poetry run vim
# if the appropriate files are detected. This allows python Coc plugins to work
# properly
alias vim="~/Dev/scripts/smartly-start-vim.sh"

# ----- Various tool initializations ------------------------------------------

# Use ripgrep instead of fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
# I got off git because this doesnt work well when adding/removing files within
# the work tree that haven't yet been staged.
# export FZF_DEFAULT_COMMAND='git ls-files 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Initialize starship prompt
eval "$(starship init zsh)"

# Configure nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NPM_LIB_PATH=$(npm root -g)
export PATH="$PATH:$NPM_LIB_PATH"

# Add terraform autocompletions
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/joemcgovern/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/joemcgovern/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/joemcgovern/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/joemcgovern/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/fzf.zsh ] && source ~/fzf.zsh

# Add globally installed npm binaries to path
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Add go binaries to path
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Add more python scripts to path
export PATH="/usr/local/opt/python@3.10/bin:$PATH"
export PATH="/Users/joemcgovern/Library/Python/3.10/bin:$PATH"

# Support pipx binaries
export PATH="$PATH:/Users/joemcgovern/.local/bin"

# Local initializations that shouldn't be pushed to an open-source repository!
[ -f ~/local.zsh ] && source ~/local.zsh
