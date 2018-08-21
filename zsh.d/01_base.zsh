#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Name			: base settings
# Licence		: MIT
# Author		: S.Nakano(https://github.com/sumeshi)
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#

# - for yellow monkey -
export LANG=ja_JP.UTF-8
setopt print_eight_bit

# - enable color -
autoload -Uz colors
colors

# - enable insane mode -
bindkey -v

# - enable completion -
autoload -Uz compinit
compinit -u

setopt auto_menu
setopt auto_cd
setopt auto_param_slash
setopt auto_param_keys
setopt globdots
setopt list_packed
setopt list_types
setopt mark_dirs
setopt print_eight_bit
setopt prompt_subst
setopt no_flow_control

export LS_COLORS='ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43:su=41;30:tw=42;30:ow=43;30'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:' list-colors ${(s.:.)LS_COLORS}

#automatically run ls after every cd
#function cd() {builtin cd $@ && ls;}
