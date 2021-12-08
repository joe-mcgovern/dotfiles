# ----- Path manipulation -----
# Path to your oh-my-zsh installation.
export ZSH="/Users/joemcgovern/.oh-my-zsh"

# Add poetry to path
export PATH="$HOME/.poetry/bin:$PATH"

# Add pipx (and other things in .local/bin) to path
export PATH="$PATH:$HOME/.local/bin"

# Add python3.9 site packages to pythonpath so vim can find globally installed
# python packages
export PYTHONPATH="$PYTHONPATH:/$HOME/.local/lib/python3.9/site-packages"


# ----- Plugins ---------------------------------------------------------------
plugins=(
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

alias tf='terraform'

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

alias gdev="export AWS_PROFILE='granappdev' && onelogin-aws-login --regenerate --profile 'granappdev' --arn 'arn:aws:iam::493050087935:role/DeveloperSSO'"
alias gtest="export AWS_PROFILE='granapptest' && onelogin-aws-login --regenerate --profile 'granapptest' --arn 'arn:aws:iam::354070167159:role/ReadOnlySSO'"
alias gprod="export AWS_PROFILE='granappprod' && onelogin-aws-login --regenerate --profile 'granappprod' --arn 'arn:aws:iam::720993478729:role/ReadOnlySSO'"
export PROD_ROLES_DB='roles-svc.coybhmjnvpai.us-east-1.rds.amazonaws.com'
alias gproddb='PGPASSWORD=$(aws --profile granappprod rds generate-db-auth-token --hostname $PROD_ROLES_DB --port 5432 --username joemcgovern --region us-east-1) psql -h $PROD_ROLES_DB -p 5432 -U joemcgovern roles '
alias dbpass='echo -n $(aws --profile granappprod rds generate-db-auth-token --hostname $PROD_ROLES_DB --port 5432 --username joemcgovern --region us-east-1) | pbcopy && echo "Copied password to clipboard!"'

# FZF aliases with git. I got these from here:
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236#file-functions-sh-L41
source /usr/local/bin/fzf-git-functions.sh
alias gc='git checkout'
alias gb='git checkout $(_gb)'
alias gs='gs_file=$(_gf) && [ -n "$gs_file" ] && vim $gs_file'
alias gl='git show $(_gh)'
alias lg="lazygit"

# ----- Various tool initializations ------------------------------------------

# Use ripgrep instead of fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
# I got off git because this doesnt work well when adding/removing files within
# the work tree that haven't yet been staged.
# export FZF_DEFAULT_COMMAND='git ls-files 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Initialize starship prompt
eval "$(starship init zsh)"

# Initialize pyenv
eval "$(pyenv init --path)"

# Initialize virtualenvwrapper
# source /usr/local/bin/virtualenvwrapper.sh

# Initialize some git + fzf integration functions that can be used as keybindings

# Configure nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NPM_LIB_PATH=$(npm root -g)
export PATH="$PATH:$NPM_LIB_PATH"

# Configure deno
export DENO_INSTALL="/Users/joemcgovern/.deno"
export PATH="$PATH:$DENO_INSTALL/bin"

# Configure qsh (terminal database UI)
export PATH="$PATH:$HOME/.qsh/bin"

# Add terraform autocompletions
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/joemcgovern/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/joemcgovern/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/joemcgovern/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/joemcgovern/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
