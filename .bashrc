
###-tns-completion-start-###
if [ -f /Users/josephmcgovern/.tnsrc ]; then
    source /Users/josephmcgovern/.tnsrc
fi
###-tns-completion-end-###
alias vi='vim'
alias tmux="TERM=screen-256color-bce tmux"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
# >>> talisman >>>
# Below environment variables should not be modified unless you know what you are doing
export TALISMAN_HOME=/Users/josephmcgovern/.talisman/bin
alias talisman=$TALISMAN_HOME/talisman_darwin_amd64
# <<< talisman <<<
