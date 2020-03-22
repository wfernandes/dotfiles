#!/bin/bash

LINK_DOTFILES=false
INIT_NVIM=false

flag=$1
if [[ "$flag" = "" ]]; then
    flag="-a"
fi

if [[ "$flag" = "-a" ]]; then
    LINK_DOTFILES=true
    INIT_NVIM=true
elif [[ "$flag" = "-l" ]]; then
    LINK_DOTFILES=true
elif [[ "$flag" = "-n" ]]; then
    INIT_NVIM=true
fi

function link_all_dotfiles {
    rcup -d dotfiles -S config/nvim -S vim -v
}

function initialize_nvim_plugins {
    nvim +PlugInstall +qall
}

brew bundle

tic tmux-256color.terminfo

if [[ "$LINK_DOTFILES" = "true" ]]; then
    link_all_dotfiles
fi
if [[ "$INIT_NVIM" = "true" ]]; then
    initialize_nvim_plugins
fi
