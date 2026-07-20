# dotfiles

## Installation

```bash
$ ./install.bash
```

Package installation (`pacman`/`apt-get`) and shell setup (`chsh`, `/etc/shells`) escalate to `sudo` internally as needed — do not prefix the whole command with `sudo`, or symlinks will be created under root's home instead of yours.

### What it does

| Step | Function | Description |
| --- | --- | --- |
| 1 | `install_essential_packages` | Detects the platform (macOS / Arch / Ubuntu / WSL) and installs base packages (curl, git, fish, tmux, fzf, vim, etc.) via the native package manager, then Homebrew (installing it first if missing) and `brew bundle` from `homebrew/Brewfile` |
| 2 | `create_directories` | Creates `~/.config/fish`, `~/.config/tmux`, `~/.vim/colors` |
| 3 | `create_symlinks` | Symlinks dotfiles (fish, git, nvim, tmux, vim + catppuccin colorscheme) from this repo into `$HOME`, backing up any existing files first |
| 4 | `setup_fish` | Registers fish in `/etc/shells` and sets it as the default shell |
| 5 | `reload_tmux` | Reloads `~/.tmux.conf` in any running tmux session |
| 6 | `finalize_setup` | Prints a completion summary and next steps |

Re-running the script is safe — existing correct symlinks and already-installed packages are skipped, and any files it would overwrite are backed up to `$XDG_STATE_HOME/dotfiles/backups/<timestamp>/` first.

### Requirements

- Install Nerd Fonts (https://github.com/ryanoasis/nerd-fonts)
