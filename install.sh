#!/bin/bash

# workdir
cd `dirname $0`

# links
mkdir -p ~/.config/fish

ln -sf "`pwd`/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
ln -sf "`pwd`/alacritty/themes" ~/.config/alacritty/themes
ln -sf "`pwd`/fish/config.fish" ~/.config/fish/config.fish
ln -sf "`pwd`/ghostty/config" ~/.config/ghostty/config
ln -sf "`pwd`/git/.gitconfig" ~/.gitconfig
ln -sf "`pwd`/git/.gitconfig_nakano" ~/.gitconfig_nakano
ln -sf "`pwd`/git/.gitignore_global" ~/.gitignore_global
ln -sf "`pwd`/google-chrome/chrome-flags.conf" ~/.config/chrome-flags.conf
ln -sf "`pwd`/systemd/xremap.service" ~/.config/systemd/user/xremap.service
ln -sf "`pwd`/tmux/tmux.conf" ~/.tmux.conf
ln -sf "`pwd`/vim/vimrc" ~/.vimrc
ln -sf "`pwd`/xremap/config.yaml" ~/.config/xremap/config.yaml

# install dependencies
sudo pacman -Syyu

## install packages
sudo pacman -Sy curl file git yay
yay -Sy fish peco bat eza fd httpie lazygit ripgrep ripgrep-all tmux
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## install fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

## install vim theme
mkdir -p ~/.vim/colors
cd ~/.vim/colors
git clone https://github.com/tomasr/molokai
mv molokai/colors/molokai.vim ~/.vim/colors/
cd `dirname $0`
