#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Name			: alias settings
# Licence		: MIT
# Author		: S.Nakano(https://github.com/sumeshi)
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# - primitive -
alias l='ls -CF'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lAh'

alias less='less -giMRSW -z-4 -x4'
alias mkdir='mkdir -p'

alias df='df -h'
alias ps='ps --sort=start_time'

alias python="python3"
alias pip="pip3"

# - user -
alias mkwd="mkdir `date '+%Y-%m-%d'`"
alias cdwd="cd `date '+%Y-%m-%d'`"

alias used="du -sh"
alias latexwatch="latexmk -pvc"