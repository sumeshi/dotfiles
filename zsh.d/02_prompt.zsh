#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Name			: prompt settings
# Licence		: MIT
# Author		: S.Nakano(https://github.com/sumeshi)
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
function zle-line-init zle-keymap-select {
case $KEYMAP in
vicmd)
PROMPT="%n/%{$fg[red]%}NOR%{$reset_color%}#%{$reset_color%} %*%\>%\ %"
;;
main|viins)
PROMPT="%n/%{$fg[cyan]%}INS%{$reset_color%}#%{$reset_color%} %*%\>%\ %"
;;
esac
zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'