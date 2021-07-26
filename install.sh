#!/bin/bash

# workdir
cd `dirname $0`

# links
ln -sf "`pwd`/vimrc" ~/.vimrc
ln -sf "`pwd`/tmux.conf" ~/.tmux.conf
ln -sf "`pwd`/config.fish" ~/.config/fish/config.fish

# 