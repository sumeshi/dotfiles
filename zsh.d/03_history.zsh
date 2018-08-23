#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Name			: history settings
# Licence		: MIT
# Author		: S.Nakano(https://github.com/sumeshi)
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=1000000
export HISTFILE=${HOME}/.zsh_history

setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt hist_reduce_blanks 
setopt hist_expand
setopt inc_append_history
setopt share_history
setopt EXTENDED_HISTORY

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
