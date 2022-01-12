export VIRTUALENVWRAPPER_PYTHON='/opt/local/bin/python3.7'
export VIRTUALENVWRAPPER_VIRTUALENV='/opt/local/bin/virtualenv-3.7'
export VIRTUALENVWRAPPER_VIRTUALENV_CLONE='/opt/local/bin/virtualenv-clone-3.7'
source /opt/local/bin/virtualenvwrapper.sh-3.7

alias ls="/usr/local/bin/gls --classify --color=auto"
alias l="ls -l"
alias ll="ls -la"
alias rm="rm -i"

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
