.DEFAULT_GOAL:=help

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[0-9A-Za-z_-]+:.*?##/ { printf "  \033[36m%-45s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

# TODO: update Makefile to work on Linux
.PHONY: all
all: ## Run all commands below
	$(MAKE) brew
	$(MAKE) link-dotfiles
	$(MAKE) init-nvim
	tic tmux-256color.terminfo

.PHONY: brew
brew: ## Brew install
	 brew bundle

.PHONY: link-dotfiles
link-dotfiles: ## Link dotfiles
	 rcup -d dotfiles -S config/nvim -S config/alacritty -S vim -v

.PHONY: init-nvim
init-nvim: ## Initialize nvim plugins and coc extensions
	 nvim +PlugInstall +qall
	## https://github.com/neoclide/coc-rls
	 nvim -c 'CocInstall -sync coc-json coc-yaml coc-git coc-rls |q'
