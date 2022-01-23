export VIRTUALENVWRAPPER_PYTHON='/usr/local/bin/python3'
export VIRTUALENVWRAPPER_VIRTUALENV='/usr/local/bin/virtualenv'
# export VIRTUALENVWRAPPER_VIRTUALENV_CLONE='/usr/local/bin/virtualenv-clone'
source /usr/local/bin/virtualenvwrapper.sh

alias ls="/usr/local/bin/gls --classify --color=auto"
alias l="ls -l"
alias ll="ls -la"
alias rm="rm -i"
alias man="/usr/local/bin/openman"
alias tabname="printf '\e]1;%s\a'"
alias winname="printf '\e]2;%s\a'"
export PS1='\[\e[1;35m\]\h:$(pwd)$\[\e[0m\] '

if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
   update_terminal_cwd() {
       # Identify the directory using a "file:" scheme URL,
       # including the host name to disambiguate local vs.
       # remote connections. Percent-escape spaces.
       local PWD_URL="file://$HOSTNAME${PWD// /%20}"
       printf '\e]7;%s\a' "$PWD_URL"
   }
   PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
fi

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    source /opt/local/etc/profile.d/bash_completion.sh
fi

if [ -s "${HOME}/.config/bash-complete-partial-path/bash_completion" ]
then
    source "${HOME}/.config/bash-complete-partial-path/bash_completion"
    _bcpp --defaults
fi

eval $(thefuck --alias)

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
