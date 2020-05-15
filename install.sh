#!/bin/bash

BREW_BUNDLE=false
LINK_DOTFILES=false
INIT_NVIM=false

flag=$1
if [[ "$flag" = "" ]]; then
    flag="-a"
fi

if [[ "$flag" = "-a" ]]; then
    LINK_DOTFILES=true
    INIT_NVIM=true
    BREW_BUNDLE=true
elif [[ "$flag" = "-l" ]]; then
    LINK_DOTFILES=true
elif [[ "$flag" = "-n" ]]; then
    echo "Initialize nvim set"
    INIT_NVIM=true
elif [[ "$flag" = "-b" ]]; then
    echo "Brew bundle set"
    BREW_BUNDLE=true
fi

function link_all_dotfiles {
    echo "Linking dotfiles"
    rcup -d dotfiles -S config/nvim -S vim -v
}

function initialize_nvim_plugins {
    echo "Initialize nvim plugins"
    nvim +PlugInstall +qall
}

function initialize_nvim_coc_extensions {
    echo "Initialize Coc extensions"
    nvim -c 'CocInstall -sync coc-json coc-yaml coc-git |q'
}

function brew_bundle {
    brew bundle
}
tic tmux-256color.terminfo

if [[ "$BREW_BUNDLE" = "true" ]]; then
    brew_bundle
fi

if [[ "$LINK_DOTFILES" = "true" ]]; then
    link_all_dotfiles
fi

if [[ "$INIT_NVIM" = "true" ]]; then
    initialize_nvim_plugins
    initialize_nvim_coc_extensions
fi

echo "Remember to install bash-completions---"
echo "git"
echo "kubectl"
