#!/bin/bash

LINK_DOTFILES=false
INIT_VIM=false

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
fi

all_dotfiles="bashrc bash_darwin bash_profile common_profile tmux.conf vimrc vim aliases git-authors gitconfig alacritty.yml rbenv"

function link {
    echo Attempting to link $1
    ln -is $PWD/$1 $HOME/.$1
}

function print_error {
    echo Failed to link $1
}

function link_all_dotfiles {
    for dotfile in $all_dotfiles; do
        if [[ -f $HOME/.$1 ]];
        then
            # file exists
            print_error $dotfile
        else
            # file does not exist
            link $dotfile
        fi
    done
}

function update_submodules {
    git submodule update --init --recursive
}

function initialize_vim_plugins {
    # install vim plugins with vundle
    vim +PluginInstall +qall
}


update_submodules
if [[ "$LINK_DOTFILES" = "true" ]]; then
    link_all_dotfiles
fi
if [[ "$INIT_VIM" = "true" ]]; then
    initialize_vim_plugins
fi
