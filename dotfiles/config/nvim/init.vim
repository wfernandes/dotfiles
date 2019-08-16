"------------------------------------------------------------------------------
" GENERAL
"------------------------------------------------------------------------------
set encoding=utf-8            " Ensure encoding is UTF-8
set nocompatible              " Disable Vi compatability
set mouse=a                   " Enable mouse in all modes
set hidden                    " Allow unwritten buffers

"-----------------------------------------------------------------------------
" VUNDLE PLUGIN MANAGEMENT
"-----------------------------------------------------------------------------
set rtp+=~/.cache/nvim/bundle/Vundle.vim    " Set the runtime path to include Vundle
call vundle#begin(expand("$HOME/.cache/nvim/bundle", 1)) " Initialize vundle
Plugin 'VundleVim/Vundle.vim'        " Let Vundle manage Vundle
Plugin 'ctrlpvim/ctrlp.vim'          " Quick file navigation
Plugin 'tpope/vim-commentary'        " Quickly comment lines out and in
Plugin 'tpope/vim-fugitive'          " Help formatting commit messages
Plugin 'tpope/vim-dispatch'          " Allow background builds
Plugin 'tpope/vim-unimpaired'        " Add normal mode aliases for commonly used ex commands
Plugin 'fatih/vim-go'                " Helpful plugin for Golang dev
Plugin 'AndrewRadev/splitjoin.vim'   " Enable vim-go to split structs into multi lines
Plugin 'vim-scripts/bufkill.vim'     " Kill buffers and leave windows intact
Plugin 'ervandew/supertab'           " Perform all completions with Tab
Plugin 'scrooloose/nerdtree'         " Directory tree explorer
Plugin 'gaving/vim-textobj-argument' " Function arguments as text objects
Plugin 'vim-airline/vim-airline'     " Status line improvements
Plugin 'regreplop.vim'               " Replace with a specified register
Plugin 'kana/vim-textobj-user'       " Needed for below
Plugin 'pianohacker/vim-indented-paragraph'
Plugin 'pianohacker/vim-textobj-variable-segment'
Plugin 'jonathanfilip/vim-lucius'    " Colorscheme not included in nvim.
Plugin 'mg979/vim-visual-multi'      " Multiple cursors.
Plugin 'jremmen/vim-ripgrep'         " :Rg for project wide search.
Plugin 'tpope/vim-surround'          " Commands to add/remove surrounds (parentheses, brackets, etc.)
Plugin 'stefandtw/quickfix-reflector.vim' " Allows editing of the entries in the quickfix list (works great with :Rg).
call vundle#end()                    " Complete vunde initialization

" detect file type, turn on that type's plugins and indent preferences
filetype plugin indent on

"-----------------------------------------------------------------------------
" VIM-GO CONFIG
"-----------------------------------------------------------------------------
let g:go_fmt_command = "goimports"

" highlight go-vim
highlight goSameId term=bold cterm=bold ctermbg=250 ctermfg=239
set updatetime=100 " updates :GoInfo faster

" vim-go command shortcuts
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t :wa<CR>:!clear;go test -v ./%:h<CR>
autocmd FileType go nmap <leader>a <Plug>(go-alternate-edit)
autocmd FileType go nmap <leader>d :GoDeclsDir<CR>
autocmd FileType go nmap <leader>g <Plug>(go-generate)
autocmd FileType go nmap <leader>? :GoDoc<CR>
autocmd FileType go nmap <leader>n :GoRename<CR>
autocmd FileType go nmap <leader>l :GoMetaLinter<CR>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

function! s:toggle_coverage()
    call go#coverage#BufferToggle(!g:go_jump_to_error)
    highlight ColorColumn ctermbg=235
    highlight NonText ctermfg=239
    highlight SpecialKey ctermfg=239
    highlight goSameId term=bold cterm=bold ctermbg=250 ctermfg=239
endfunction

autocmd FileType go nmap <leader>c :<C-u>call <SID>toggle_coverage()<CR>

" This will add new commands, called :A, :AV, :AS and :AT. Here :A works just
" like :GoAlternate, it replaces the current buffer with the alternate file.
" :AV will open a new vertical split with the alternate file. :AS will open
" the alternate file in a new split view and :AT in a new tab.
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

"-----------------------------------------------------------------------------
" RUBY CONFIG
"-----------------------------------------------------------------------------
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2

"-----------------------------------------------------------------------------
" CTRL-P CONFIG
"-----------------------------------------------------------------------------
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn|vagrant)|node_modules)$',
  \ 'file': '\v\.(swp|zip|exe|so|dll|a)$',
  \ }
" stop setting git repo as root path
let g:ctrlp_working_path_mode = ''

"-----------------------------------------------------------------------------
" nerd tree config
"-----------------------------------------------------------------------------
map <C-n> :NERDTreeToggle<CR>
map \| :NERDTreeFind<CR>
"------------------------------------------------------------------------------
" APPEARANCE
"------------------------------------------------------------------------------
syntax on               " enable syntax highlighting
set number              " show line numbers
set ruler               " show lines in lower right
set nowrap              " don't wrap lines eva!

colorscheme lucius      " color scheme
set cursorline          " highlight current line
let loaded_matchparen = 1

set t_Co=256            " set 256 color
set colorcolumn=80      " highlight col 80
highlight ColorColumn ctermbg=235
set listchars=tab:▸\ ,eol:¬,trail:· " show whitespace characters
set list                " enable display of invisible characters

" invisible character colors
highlight NonText ctermfg=239
highlight SpecialKey ctermfg=239


"------------------------------------------------------------------------------
" supertab config
"------------------------------------------------------------------------------
let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

"------------------------------------------------------------------------------
" vim-visual-multi config
"------------------------------------------------------------------------------
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-g>'
let g:VM_maps['Find Subword Under'] = '<C-g>'
let g:VM_maps['Add Cursor Up'] = '<M-Up>'
let g:VM_maps['Add Cursor Down'] = '<M-Down>'

"------------------------------------------------------------------------------
" BEHAVIOR
"------------------------------------------------------------------------------
set exrc                        " Allow .nvimrc files in project directories
set inccommand=nosplit          " Show the result of :s commands as they're typed
set undofile                    " Persist undo across sessions

set backspace=indent,eol,start  " enable better backspacing
set noswapfile                  " disable swap files
set nowb                        " disable writing backup
set textwidth=78                " global text columns
set formatoptions+=c            " don't break long lines less they are comments
set formatoptions-=t            " don't break long lines

set ignorecase                  " required for smartcase
set hlsearch                    " highlight search results
set smartcase                   " ignore case if lower, otherwise match case
set incsearch                   " jump to results as I search
set splitbelow                  " split panes on the bottom
set splitright                  " split panes to the right

set history=10000               " keep a longer history

set wildmenu                    " allow for menu suggestions

set autowrite                   " automatically write file on `:make`

autocmd BufWritePre * :%s/\s\+$//e " strip trailing whitespace on save
autocmd BufLeave * silent! wall    " save on lost focus

" tab behavior
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" smaller indents for yaml
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 expandtab

"------------------------------------------------------------------------------
" LEADER MAPPINGS
"------------------------------------------------------------------------------
let mapleader = ","              " set leader

" switch between files
nnoremap <leader><leader> <c-^>

" quickly Open vimrc
nmap <silent> <leader>ev :edit $MYVIMRC<cr>
" load vimrc into memory
nmap <silent> <leader>ee :source $MYVIMRC<cr>

nnoremap <leader>s :w<cr>
nnoremap <leader>q :x<cr>

" clear the search buffer when hitting space
nnoremap <space> :nohlsearch<cr>

" reselect when indenting
vnoremap < <gv
vnoremap > >gv

" clipboard fusion!
"set clipboard^=unnamed clipboard^=unnamedplus

" turn folding on and open by default
set foldmethod=syntax
set foldlevel=99

" remove the need to hit c-w for navigating splits
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-h> <c-w>h
nmap <c-l> <c-w>l
set laststatus=2

" resize windows more easily
nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3)<CR>

call textobj#user#map('indentedparagraph', {
\   '-': {
\     'move-n': ')',
\     'move-p': '(',
\   }
\ })
