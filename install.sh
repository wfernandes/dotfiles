#!/bin/bash

LINK_DOTFILES=false
INIT_VIM=false
INIT_NVIM=false

flag=$1
if [[ "$flag" = "" ]]; then
    flag="-a"
fi

if [[ "$flag" = "-a" ]]; then
    LINK_DOTFILES=true
    INIT_VIM=true
elif [[ "$flag" = "-l" ]]; then
    LINK_DOTFILES=true
elif [[ "$flag" = "-p" ]]; then
    INIT_VIM=true
elif [[ "$flag" = "-n" ]]; then
    INIT_NVIM=true
fi

function link_all_dotfiles {
    rcup -d dotfiles -S config/nvim -S vim -v
}

function update_submodules {
    git submodule update --init --recursive
}

function initialize_vim_plugins {
    # install vim plugins with vundle
    vim +PluginInstall +qall
}

function initialize_nvim_plugins {
    # install nvim plugins with vundle
    nvim +PluginInstall +qall
}

brew bundle

tic tmux-256color.terminfo

update_submodules
if [[ "$LINK_DOTFILES" = "true" ]]; then
    link_all_dotfiles
fi
if [[ "$INIT_VIM" = "true" ]]; then
    initialize_vim_plugins
fi
if [[ "$INIT_NVIM" = "true" ]]; then
    mkdir -p ~/.config
    ln -is $PWD/nvim ~/.config/nvim
    initialize_nvim_plugins
fi
