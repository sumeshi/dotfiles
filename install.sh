#!/bin/bash
#-----link-----
cd `dirname $0`
ln -sf "`pwd`/zshrc" ~/.zshrc
ln -sf "`pwd`/zsh.d" ~/.zsh.d
ln -sf "`pwd`/vimrc" ~/.vimrc
