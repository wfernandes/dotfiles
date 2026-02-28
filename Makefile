.DEFAULT_GOAL := help

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[0-9A-Za-z_-]+:.*?##/ { printf "  \033[36m%-45s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: install
install: ## Bootstrap everything (Homebrew, packages, oh-my-zsh, dotfiles, nvim)
	./install.sh

.PHONY: brew
brew: ## Run brew bundle only
	brew bundle

.PHONY: link-dotfiles
link-dotfiles: ## Link dotfiles via rcup
	rcup -d dotfiles -S config/nvim -S config/alacritty -S vim -v

.PHONY: init-nvim
init-nvim: ## Sync nvim plugins via lazy.nvim (LSP servers auto-install on first open)
	nvim --headless "+Lazy! sync" +qa
