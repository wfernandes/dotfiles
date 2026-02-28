#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { echo "[info]  $*"; }
success() { echo "[ok]    $*"; }
warn()    { echo "[warn]  $*"; }

# ── Homebrew ──────────────────────────────────────────────────────────────────
install_homebrew() {
    if command -v brew &>/dev/null; then
        info "Homebrew already installed, updating..."
        brew update --quiet
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add brew to PATH for this session (Apple Silicon default path)
        eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
    fi
    success "Homebrew ready"
}

# ── Brew bundle ───────────────────────────────────────────────────────────────
run_brew_bundle() {
    info "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    success "Brew bundle complete"
}

# ── oh-my-zsh ─────────────────────────────────────────────────────────────────
install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        info "oh-my-zsh already installed"
    else
        info "Installing oh-my-zsh..."
        RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        success "oh-my-zsh installed"
    fi
}

# ── Link dotfiles ─────────────────────────────────────────────────────────────
link_dotfiles() {
    info "Linking dotfiles via rcup..."
    rcup -d "$DOTFILES_DIR/dotfiles" -S config/nvim -S config/alacritty -S vim -v
    success "Dotfiles linked"
}

# ── Neovim ────────────────────────────────────────────────────────────────────
init_nvim() {
    if ! command -v nvim &>/dev/null; then
        warn "nvim not found, skipping plugin install"
        return
    fi
    info "Installing nvim plugins via lazy.nvim..."
    nvim --headless "+Lazy! sync" +qa
    success "Neovim ready (LSP servers will install automatically on first open)"
}

# ── tmux terminfo ─────────────────────────────────────────────────────────────
install_terminfo() {
    info "Installing tmux-256color terminfo..."
    tic "$DOTFILES_DIR/tmux-256color.terminfo"
    success "terminfo installed"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
    echo ""
    echo "╔══════════════════════════════════╗"
    echo "║   dotfiles bootstrap installer   ║"
    echo "╚══════════════════════════════════╝"
    echo ""

    install_homebrew
    run_brew_bundle
    install_oh_my_zsh
    link_dotfiles
    init_nvim
    install_terminfo

    echo ""
    success "All done! Restart your terminal (or run: source ~/.zshrc)"
}

main "$@"
