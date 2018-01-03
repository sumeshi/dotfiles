#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#zsh settings

autoload -U colors
colors

autoload -Uz compinit
compinit -u

setopt prompt_subst

bindkey -v

setopt auto_menu
setopt auto_param_slash
setopt auto_param_keys
setopt globdots
setopt list_packed
setopt list_types
setopt mark_dirs
setopt print_eight_bit

export LS_COLORS='ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43:su=41;30:tw=42;30:ow=43;30'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:' list-colors ${(s.:.)LS_COLORS}

#automatically run ls after every cd
#function cd() {builtin cd $@ && ls;}


#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#zsh prompt

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
RPROMPT='[%d]'

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#zsh history
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=1000000

setopt hist_ignore_dups
setopt share_history
setopt EXTENDED_HISTORY
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt hist_reduce_blanks 
setopt hist_expand
setopt inc_append_history

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#alias settings

alias ls='ls -G'
alias grep='grep -G'
alias less="less -giMRSW -z-4 -x4"
alias df="df -h"
alias ps="ps --sort=start_time"
alias sed="gsed"

alias aliasset='vim ~/.zshrc'
alias zshset='vim /etc/zshrc'
alias sourset='source /etc/zshrc ; source ~/.zshrc ; source ~/.bashrc'
alias vimset='vim ~/.vimrc'

alias vim='env_LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

alias mkwd="mkdir `date '+%Y-%m-%d'`"
alias cdwd="cd `date '+%Y-%m-%d'`"

alias l='ls -CF'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lAh'

alias used="du -sh"

#setacmd
alias cdgit="cd ~/github/github.io"
alias scss="sass --cache-location ~/.sass-cache --sourcemap=none --style expanded --watch scss:css"

#setacmd_end

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#function settings

#---set alias---#
seta(){
	if [ $# -eq 2 ];
	then
		sed -i "/^#setacmd$/a alias $1="\"$2\""" /Users/user/github/macOS/zshrc
		sourset
	else
		echo "arguments are invalid." 1>&2
	fi
}

#---unset alias---#
unseta(){
	if [ $# -eq 1 ];
	then
		sed -ie "/^alias $1=/d" /Users/user/github/macOS/zshrc
		sourset
	else
		echo "arguments are invalid." 1>&2
	fi
}

gitupdate(){
	git add *;
	git commit -m "update";
	git push -u origin master
}

removeDS(){
	find $1 -name ".DS_Store" -print -exec rm {} ";"
}

#-----memory directory-----#
memdir=()

memd(){
	if [ "$1" = "" ]
	then
		memnum=1
	else
		memnum=$1
	fi

	memdir[$memnum]=("$memnum: `pwd`")
	echo "$memdir[$memnum] is saved in memdir[$memnum]"
}

cdmemd(){
	if [ "$1" = "" ]
	then
		memnum=1
	else
		memnum=$1
	fi

	cd `echo ${=memdir[$memnum]#*: }`
}

lsmemd(){
	for i in "${memdir[@]}"
	do
		if [ "$i" != "" ]
		then
			echo "$i"
		fi
	done
}


grepstring(){
  grep -rnw ./ -e "$1"
}

function ranger() {
  if [ -z "$RANGER_LEVEL" ]; then
	/usr/local/bin/ranger $@
  else
	exit
  fi
}

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#path settings

PATH="$PATH":/usr/bin/ls
PATH="$PATH":/usr/bin/bash
export PATH="$PATH":/usr/local/sbin
export PATH="$PATH":/Library/TeX/texbin
export PATH="$PATH":$HOME/.nodebrew/current/bin
export PATH="$PATH":$HOME/.rbenv/bin
export PATH="$PATH":$HOME/.nodebrew/current/bin

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
function initruby() {
  if which rbenv > /dev/null;
  then
	  eval "$(rbenv init -)";
  fi
}
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
function initpython() {
  export PYENV_ROOT=${HOME}/.pyenv
  if [ -d "${PYENV_ROOT}" ]; then
	  export PATH=${PYENV_ROOT}/bin:$PATH
	  eval "$(pyenv init -)"
	  eval "$(pyenv virtualenv-init -)"
  fi
}

initpython

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# ssh settings
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#boot settings
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startxfce4

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#gcloud settings
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/user/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/user/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/user/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/user/google-cloud-sdk/completion.zsh.inc'; fi

