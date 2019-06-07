let g:oratos_vundle_path=expand("$HOME/.cache/nvim/bundle", 1)
let g:oratos_vundle_extra_plugins="Plugin 'jonathanfilip/vim-lucius'
\ | Plugin 'mg979/vim-visual-multi'
\ | Plugin 'jremmen/vim-ripgrep'
\ | Plugin 'stefandtw/quickfix-reflector.vim'"
set rtp+=~/.cache/nvim/bundle/Vundle.vim    " Set the runtime path to include Vundle

source $HOME/.vimrc

set exrc " Allow .nvimrc files in project directories
set inccommand=nosplit " Show the result of :s commands as they're typed
set undofile " Persist undo across sessions
