#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if command exists
command_exists() { command -v "$1" >/dev/null 2>&1; }

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi "microsoft" /proc/version 2>/dev/null; then
            echo "wsl"
        elif command_exists pacman; then
            echo "arch"
        elif command_exists apt; then
            echo "ubuntu"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Main installation function
main() {
    cd "$(dirname "$0")"
    local DOTFILES_DIR="$(pwd)"
    local PLATFORM=$(detect_platform)

    log_info "Starting dotfiles installation from: $DOTFILES_DIR"
    log_info "Detected platform: $PLATFORM"

    # Create directories
    create_directories

    # Create symbolic links
    create_symlinks "$DOTFILES_DIR"

    # Install essential packages only
    install_essential_packages "$PLATFORM" "$DOTFILES_DIR"

    # Setup fish shell
    setup_fish "$DOTFILES_DIR"

    # Final setup
    finalize_setup
}

# Create necessary directories
create_directories() {
    log_info "Creating directories..."
    mkdir -p ~/.config/fish ~/.vim/colors
    # mkdir -p ~/.config/{ghostty,systemd/user,xremap}  # Uncomment if needed
}

# Create symbolic links
create_symlinks() {
    local dotfiles_dir="$1"
    log_info "Creating symbolic links..."

    local links=(
        "fish/config.fish:~/.config/fish/config.fish"
        "git/.gitconfig:~/.gitconfig"
        "git/.gitconfig_sumeshi:~/.gitconfig_sumeshi"
        "git/.gitignore_global:~/.gitignore_global"
        "nvim:~/.config/nvim"
        "tmux/tmux.conf:~/.tmux.conf"
        "vim/vimrc:~/.vimrc"
        # Optional configs (uncomment as needed):
        # "ghostty/config:~/.config/ghostty/config"
        # "google-chrome/chrome-flags.conf:~/.config/chrome-flags.conf"
        # "systemd/xremap.service:~/.config/systemd/user/xremap.service"
        # "xremap/config.yaml:~/.config/xremap/config.yaml"
    )

    for link in "${links[@]}"; do
        [[ "$link" =~ ^[[:space:]]*# ]] && continue  # Skip commented lines
        
        local src="${link%%:*}"
        local dest="${link##*:}"
        local dest_expanded="${dest/#\~/$HOME}"
        
        if [[ ! -e "$dotfiles_dir/$src" ]]; then
            log_warning "Source file/directory not found: $src"
            continue
        fi
        
        local dest_dir=$(dirname "$dest_expanded")
        [[ ! -d "$dest_dir" ]] && mkdir -p "$dest_dir"
        
        if [[ -L "$dest_expanded" && "$(readlink "$dest_expanded")" == "$dotfiles_dir/$src" ]]; then
            log_info "Link exists: $dest"
        else
            # Remove existing file/directory if it exists
            [[ -e "$dest_expanded" || -L "$dest_expanded" ]] && rm -rf "$dest_expanded"
            ln -sf "$dotfiles_dir/$src" "$dest_expanded"
            log_success "Created: $dest"
        fi
    done
}

# Install essential packages only
install_essential_packages() {
    local platform="$1"
    local dotfiles_dir="$2"

    case "$platform" in
        "macos")
            install_homebrew_packages "$dotfiles_dir"
            ;;
        "arch")
            install_arch_essentials
            ;;
        "ubuntu"|"wsl")
            install_ubuntu_essentials
            ;;
        *)
            log_warning "Unknown platform: $platform"
            ;;
    esac
}

# Homebrew package installation (macOS)
install_homebrew_packages() {
    local dotfiles_dir="$1"
    
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    log_info "Installing packages via Homebrew..."
    if [[ -f "$dotfiles_dir/homebrew/Brewfile" ]]; then
        brew bundle --file="$dotfiles_dir/homebrew/Brewfile"
        log_success "Homebrew packages installed"
    else
        log_warning "Brewfile not found"
    fi
}

# Arch Linux essentials only
install_arch_essentials() {
    log_info "Installing essential packages..."
    sudo pacman -Syu --noconfirm
    
    local essentials=(curl git fish)
    for pkg in "${essentials[@]}"; do
        if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
            sudo pacman -S --noconfirm "$pkg" || log_warning "Failed to install: $pkg"
        fi
    done
    
    log_info "For additional packages, install Homebrew first, then: brew bundle --file=homebrew/Brewfile"
}

# Ubuntu/WSL essentials only
install_ubuntu_essentials() {
    log_info "Installing essential packages..."
    sudo apt update && sudo apt upgrade -y
    
    local essentials=(curl git fish build-essential procps file)
    for pkg in "${essentials[@]}"; do
        if ! dpkg -l | grep -q "^ii.*$pkg"; then
            sudo apt install -y "$pkg" || log_warning "Failed to install: $pkg"
        fi
    done
    
    # Install Homebrew for Linux
    if ! command_exists brew; then
        log_info "Installing Homebrew for Linux..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add to PATH for current session
        if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi
    
    # Install packages via Homebrew
    if command_exists brew; then
        log_info "Installing packages via Homebrew..."
        brew bundle --file=homebrew/Brewfile
    fi
}

# Setup fish shell
setup_fish() {
    local dotfiles_dir="$1"
    
    if ! command_exists fish; then
        log_warning "Fish shell not found. Install it first, then run fish/setup_fish.fish"
        return
    fi

    log_info "Setting fish as default shell..."
    local fish_path=$(which fish)
    if [[ "$SHELL" != "$fish_path" ]]; then
        if ! grep -q "$fish_path" /etc/shells; then
            echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
        fi
        chsh -s "$fish_path" || log_warning "Failed to set fish as default shell"
    fi
    
    log_info "To setup fish extensions, run: fish fish/setup_fish.fish"
}

# Install vim theme
install_vim_theme() {
    if [[ ! -f ~/.vim/colors/molokai.vim ]]; then
        log_info "Installing vim molokai theme..."
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"
        git clone https://github.com/tomasr/molokai.git
        cp molokai/colors/molokai.vim ~/.vim/colors/
        cd - && rm -rf "$temp_dir"
    fi
}

# Final setup and messages
finalize_setup() {
    install_vim_theme
    
    log_success "Dotfiles installation completed!"
    log_info ""
    log_info "Next steps:"
    log_info "  1. Restart your terminal or run 'exec fish'"
    log_info "  2. Setup fish extensions: fish fish/setup_fish.fish"
    log_info ""
    log_info "Optional configurations (uncomment in install.sh):"
    log_info "  • Ghostty terminal emulator"
    log_info "  • Google Chrome Wayland flags" 
    log_info "  • xremap key remapping"
}

# Run main function
main "$@"
