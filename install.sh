#!/bin/bash

# workdir
cd `dirname $0`

# links
mkdir -p ~/.config/fish

ln -sf "`pwd`/vimrc" ~/.vimrc
ln -sf "`pwd`/tmux.conf" ~/.tmux.conf
ln -sf "`pwd`/.Xmodmap" ~/.Xmodmap
ln -sf "`pwd`/.xprofile" ~/.xprofile
ln -sf "`pwd`/i3config" ~/.config/i3/config
ln -sf "`pwd`/config.fish" ~/.config/fish/config.fish
ln -sf "`pwd`/.gitconfig" ~/.gitconfig
ln -sf "`pwd`/.gitconfig_nakano" ~/.gitconfig_nakano
ln -sf "`pwd`/.gitignore_global" ~/.gitignore_global

# install dependencies
sudo pacman -Syyu

## install homebrew
sudo pacman -Sy procps curl file git fish peco feh yay xorg-xmodmap
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## install fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

## vim monokai theme
mkdir -p ~/.vim/colors
cd ~/.vim/colors
git clone https://github.com/tomasr/molokai
mv molokai/colors/molokai.vim ~/.vim/colors/
cd `dirname $0`
