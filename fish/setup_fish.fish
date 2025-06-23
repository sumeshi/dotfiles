#!/usr/bin/fish

# Install fisher if not exists
if not test -f ~/.config/fish/functions/fisher.fish
    echo "Installing fisher..."
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

# Install fisher packages
fisher install 0rax/fish-bd
fisher install PatrickF1/fzf.fish 