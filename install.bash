#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_DIR="$SCRIPT_DIR"
BREWFILE="$DOTFILES_DIR/homebrew/Brewfile"

BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups"
BACKUP_DIR="$BACKUP_ROOT/$(date '+%Y%m%d-%H%M%S')"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    RED=$'\033[0;31m'
    GREEN=$'\033[0;32m'
    YELLOW=$'\033[1;33m'
    BLUE=$'\033[0;34m'
    NC=$'\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

log_info() {
    printf '%s[INFO]%s %s\n' "$BLUE" "$NC" "$*"
}

log_success() {
    printf '%s[SUCCESS]%s %s\n' "$GREEN" "$NC" "$*"
}

log_warning() {
    printf '%s[WARNING]%s %s\n' "$YELLOW" "$NC" "$*"
}

log_error() {
    printf '%s[ERROR]%s %s\n' "$RED" "$NC" "$*" >&2
}

die() {
    log_error "$*"
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

on_error() {
    local exit_code=$?
    local line_number=$1

    log_error "Installation failed at line $line_number with exit code $exit_code."
    exit "$exit_code"
}

trap 'on_error "$LINENO"' ERR

detect_platform() {
    case "$(uname -s)" in
        Darwin)
            printf '%s\n' "macos"
            ;;

        Linux)
            if [[ -n "${WSL_DISTRO_NAME:-}" ]] ||
                grep -qiE '(microsoft|wsl)' /proc/version 2>/dev/null; then
                printf '%s\n' "wsl"
            elif command_exists pacman; then
                printf '%s\n' "arch"
            elif command_exists apt-get; then
                printf '%s\n' "ubuntu"
            else
                printf '%s\n' "linux"
            fi
            ;;

        *)
            printf '%s\n' "unknown"
            ;;
    esac
}

create_directories() {
    log_info "Creating directories..."

    mkdir -p \
        "$HOME/.config/fish" \
        "$HOME/.config/tmux" \
        "$HOME/.vim/colors"
}

backup_existing_path() {
    local path=$1
    local relative_path
    local backup_path

    relative_path="${path#"$HOME"/}"
    backup_path="$BACKUP_DIR/$relative_path"

    mkdir -p "$(dirname "$backup_path")"
    mv "$path" "$backup_path"

    log_warning "Moved existing path to: $backup_path"
}

create_symlink() {
    local source_path=$1
    local destination_path=$2

    if [[ ! -e "$source_path" && ! -L "$source_path" ]]; then
        log_warning "Source not found: $source_path"
        return
    fi

    mkdir -p "$(dirname "$destination_path")"

    if [[ -L "$destination_path" ]] &&
        [[ "$(readlink "$destination_path")" == "$source_path" ]]; then
        log_info "Link already exists: $destination_path"
        return
    fi

    if [[ -e "$destination_path" || -L "$destination_path" ]]; then
        backup_existing_path "$destination_path"
    fi

    ln -s "$source_path" "$destination_path"
    log_success "Created link: $destination_path"
}

create_symlinks() {
    local link
    local source_relative
    local destination
    local source_path
    local destination_path

    local links=(
        "fish/config.fish:~/.config/fish/config.fish"
        "git/.gitconfig:~/.gitconfig"
        "git/.gitconfig_sumeshi:~/.gitconfig_sumeshi"
        "git/.gitignore_global:~/.gitignore_global"
        "nvim:~/.config/nvim"
        "tmux/tmux.conf:~/.tmux.conf"
        "tmux/menu.fish:~/.config/tmux/menu.fish"
        "vim/vimrc:~/.vimrc"
        "vim/colors/catppuccin_mocha.vim:~/.vim/colors/catppuccin_mocha.vim"
    )

    log_info "Creating symbolic links..."

    for link in "${links[@]}"; do
        source_relative="${link%%:*}"
        destination="${link#*:}"

        source_path="$DOTFILES_DIR/$source_relative"
        destination_path="${destination/#\~/$HOME}"

        create_symlink "$source_path" "$destination_path"
    done

    if [[ -f "$DOTFILES_DIR/tmux/menu.fish" ]]; then
        chmod +x "$DOTFILES_DIR/tmux/menu.fish"
    fi
}

discover_homebrew() {
    local candidate

    if command_exists brew; then
        return
    fi

    local candidates=(
        "/opt/homebrew/bin/brew"
        "/usr/local/bin/brew"
        "/home/linuxbrew/.linuxbrew/bin/brew"
        "$HOME/.linuxbrew/bin/brew"
    )

    for candidate in "${candidates[@]}"; do
        if [[ -x "$candidate" ]]; then
            eval "$("$candidate" shellenv)"
            return
        fi
    done
}

ensure_homebrew() {
    discover_homebrew

    if command_exists brew; then
        return
    fi

    command_exists curl ||
        die "curl is required to install Homebrew."

    log_info "Installing Homebrew..."

    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    discover_homebrew
    command_exists brew ||
        die "Homebrew was installed but could not be added to PATH."
}

install_brew_bundle() {
    if [[ ! -f "$BREWFILE" ]]; then
        log_warning "Brewfile not found: $BREWFILE"
        return
    fi

    log_info "Installing packages from Brewfile..."
    brew bundle --file="$BREWFILE"
    log_success "Homebrew packages installed."
}

install_macos_packages() {
    ensure_homebrew

    if [[ -f "$BREWFILE" ]]; then
        install_brew_bundle
    else
        log_info "Installing essential Homebrew packages..."
        brew install git fish tmux fzf vim
    fi
}

install_arch_packages() {
    local packages=(
        curl
        git
        fish
        tmux
        fzf
        vim
        base-devel
        procps-ng
        file
    )

    log_info "Installing Arch Linux packages..."

    sudo pacman \
        -Syu \
        --needed \
        --noconfirm \
        "${packages[@]}"

    if command_exists brew && [[ -f "$BREWFILE" ]]; then
        install_brew_bundle
    else
        log_info "Homebrew bundle installation was skipped."
    fi
}

install_ubuntu_packages() {
    local packages=(
        curl
        git
        fish
        tmux
        fzf
        vim
        build-essential
        procps
        file
    )

    log_info "Installing Ubuntu packages..."

    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"

    ensure_homebrew
    install_brew_bundle
}

install_essential_packages() {
    local platform=$1

    case "$platform" in
        macos)
            install_macos_packages
            ;;

        arch)
            install_arch_packages
            ;;

        ubuntu | wsl)
            install_ubuntu_packages
            ;;

        linux)
            log_warning "Unsupported Linux distribution. Package installation was skipped."
            ;;

        *)
            log_warning "Unsupported platform. Package installation was skipped."
            ;;
    esac
}

setup_fish() {
    local fish_path

    if ! command_exists fish; then
        log_warning "Fish shell is not installed."
        return
    fi

    fish_path="$(command -v fish)"

    if [[ "${SHELL:-}" == "$fish_path" ]]; then
        log_info "Fish is already the default shell."
        return
    fi

    log_info "Setting fish as the default shell..."

    if ! grep -Fxq "$fish_path" /etc/shells; then
        printf '%s\n' "$fish_path" |
            sudo tee -a /etc/shells >/dev/null
    fi

    if chsh -s "$fish_path"; then
        log_success "Default shell changed to fish."
    else
        log_warning "Failed to change the default shell."
    fi
}

reload_tmux() {
    if ! command_exists tmux; then
        return
    fi

    if ! tmux list-sessions >/dev/null 2>&1; then
        return
    fi

    if tmux source-file "$HOME/.tmux.conf"; then
        log_success "Reloaded tmux configuration."
    else
        log_warning "Failed to reload tmux configuration."
    fi
}

finalize_setup() {
    log_success "Dotfiles installation completed."

    if [[ -d "$BACKUP_DIR" ]]; then
        log_info "Existing files were backed up to: $BACKUP_DIR"
    fi

    log_info "Restart the terminal or run: exec fish"
    log_info "Install fish extensions with: fish fish/setup_fish.fish"
}

main() {
    local platform

    platform="$(detect_platform)"

    log_info "Dotfiles directory: $DOTFILES_DIR"
    log_info "Detected platform: $platform"

    install_essential_packages "$platform"
    create_directories
    create_symlinks
    setup_fish
    reload_tmux
    finalize_setup
}

main "$@"
