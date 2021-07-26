#!/bin/bash

# workdir
cd `dirname $0`

# links
ln -sf "`pwd`/vimrc" ~/.vimrc
ln -sf "`pwd`/tmux.conf" ~/.tmux.conf
ln -sf "`pwd`/config.fish" ~/.config/fish/config.fish
ln -sf "`pwd`/.gitconfig" ~/.gitconfig
ln -sf "`pwd`/.gitconfig_nakano" ~/.gitconfig_nakano
ln -sf "`pwd`/.gitignore_global" ~/.gitignore_global

# install dependencies
sudo apt update

## install homebrew
sudo apt install build-essential procps curl file git fish
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## install fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# install packages
brew bundle

# install extensions

## fisher packages
fisher install jethrokuan/z
fisher install 0rax/fish-bd
fisher install oh-my-fish/plugin-peco
fisher install tsu-nera/fish-peco_recentd

## vim monokai theme
mkdir -p ~/.vim/colors
cd ~/.vim/colors
git clone https://github.com/tomasr/molokai
mv molokai/colors/molokai.vim ~/.vim/colors/
cd `dirname $0`
