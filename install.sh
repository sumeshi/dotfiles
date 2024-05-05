#!/bin/bash

# set workingdir to currentdir
cd `dirname $0`

# symbolic links
mkdir -p ~/.config/fish

ln -sf "`pwd`/vim/vimrc" ~/.vimrc
ln -sf "`pwd`/nvim" ~/.config/nvim
ln -sf "`pwd`/tmux/tmux.conf" ~/.tmux.conf
ln -sf "`pwd`/fish/config.fish" ~/.config/fish/config.fish
ln -sf "`pwd`/git/.gitconfig" ~/.gitconfig
ln -sf "`pwd`/git/.gitconfig_nakano" ~/.gitconfig_nakano
ln -sf "`pwd`/git/.gitignore_global" ~/.gitignore_global

# install applications
## apt
apt update
apt upgrade -y

## homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## applications
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
brew bundle --file "`pwd`/homebrew/Brewfile"

## fisher
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

## fisher packages
fish -c "fisher install jethrokuan/z"
fish -c "fisher install PatrickF1/fzf.fish"

## vim monokai theme
mkdir -p ~/.vim/colors
cd ~/.vim/colors
git clone https://github.com/tomasr/molokai
mv molokai/colors/molokai.vim ~/.vim/colors/
cd `dirname $0`
