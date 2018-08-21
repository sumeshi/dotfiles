#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Name			: OS settings
# Licence		: MIT
# Author		: S.Nakano(https://github.com/sumeshi)
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
case ${OSTYPE} in
  darwin*)
    alias ls='ls -G'
    alias grep='grep -G'
    alias sed="gsed"
    alias vim='env_LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
    ;;
  linux*)
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    ;;
esac