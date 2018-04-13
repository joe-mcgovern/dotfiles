
###-tns-completion-start-###
if [ -f /Users/josephmcgovern/.tnsrc ]; then
    source /Users/josephmcgovern/.tnsrc
fi
###-tns-completion-end-###
alias vi='vim'
alias tmux="TERM=screen-256color-bce tmux"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/josephmcgovern/google-cloud-sdk/path.bash.inc' ]; then source '/Users/josephmcgovern/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/josephmcgovern/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/josephmcgovern/google-cloud-sdk/completion.bash.inc'; fi
