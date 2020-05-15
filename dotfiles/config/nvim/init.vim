" -------------------------------------------------------------------------------------------------
" Plugins
" -------------------------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Use release branch (recommened)
Plug 'preservim/nerdtree'         " visual file hierarchy navigation
Plug 'ctrlpvim/ctrlp.vim'         " Quick file navigation
Plug 'tpope/vim-commentary'       " Quickly comment lines out and in
Plug 'tpope/vim-surround'         " Quickly surround text with stuff
Plug 'tpope/vim-fugitive'         " Help formatting commit messages
Plug 'jonathanfilip/vim-lucius'   " Colorscheme not included in nvim.
Plug 'AndrewRadev/splitjoin.vim'  " Enable vim-go to split structs into multi lines
Plug 'jremmen/vim-ripgrep'        " :Rg for project wide search.
call plug#end()

"------------------------------------------------------------------------------
" GENERAL
"------------------------------------------------------------------------------
set encoding=utf-8            " Ensure encoding is UTF-8
set nocompatible              " Disable Vi compatability
set mouse=a                   " Enable mouse in all modes
set hidden                    " Allow unwritten buffers

"------------------------------------------------------------------------------
" APPEARANCE
"------------------------------------------------------------------------------
syntax on                   " enable syntax highlighting
set number relativenumber   " show hybrid line number
set ruler                   " show lines in lower right
set nowrap                  " don't wrap lines eva!

colorscheme lucius          " color scheme
"set cursorline             " highlight current line
let loaded_matchparen = 1

set t_Co=256                " set 256 color
set colorcolumn=80          " highlight col 80
highlight ColorColumn ctermbg=235
set listchars=tab:▸\ ,eol:¬,trail:· " show whitespace characters
set list                            " enable display of invisible characters

" invisible character colors
highlight NonText ctermfg=239
highlight SpecialKey ctermfg=239

"------------------------------------------------------------------------------
" BEHAVIOR
"------------------------------------------------------------------------------
set exrc                         " Allow .nvimrc files in project directories
"set inccommand=nosplit           " Show the result of :s commands as they're typed
set undofile                     " Persist undo across sessions

set backspace=indent,eol,start   " enable better backspacing
set noswapfile                   " disable swap files
set nowb                         " disable writing backup
set textwidth=78                 " global text columns
set formatoptions+=c             " don't break long lines less they are comments
set formatoptions-=t             " don't break long lines

set ignorecase                   " required for smartcase
set hlsearch                     " highlight search results
set smartcase                    " ignore case if lower, otherwise match case
set incsearch                    " jump to results as I search
set splitbelow                   " split panes on the bottom
set splitright                   " split panes to the right

set history=10000                " keep a longer history

set wildmenu                     " allow for menu suggestions

set autowrite                    " automatically write file on `:make`

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

" show search count message when searching
set shortmess-=S

"-----------------------------------------------------------------------------
" VIM-GO CONFIG
"-----------------------------------------------------------------------------
let g:go_fmt_command = "goimports"

" vim-go command shortcuts
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t :wa<CR>:!clear;go test -v ./%:h<CR>
autocmd FileType go nmap <leader>a <Plug>(go-alternate-edit)
autocmd Filetype go nmap <leader>ah <Plug>(go-alternate-split)
autocmd Filetype go nmap <leader>av <Plug>(go-alternate-vertical)
autocmd FileType go nmap <leader>d :GoDeclsDir<CR>
autocmd FileType go nmap <leader>g <Plug>(go-generate)
autocmd FileType go nmap <leader>? :GoDoc<CR>
autocmd FileType go nmap <leader>n :GoRename<CR>
autocmd FileType go nmap <leader>l :GoMetaLinter<CR>

" Show type information in status line
let g:go_auto_type_info = 1

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
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_types = 1

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

" -------------------------------------------------------------------------------------------------
" NerdTree Config
" -------------------------------------------------------------------------------------------------
map <C-n> :NERDTreeToggle<CR>


" -------------------------------------------------------------------------------------------------
" coc.nvim default settings
" -------------------------------------------------------------------------------------------------

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" use signcolumns default. Original value: yes
set signcolumn=auto

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
" disabling this to allow CoC to handle go to definition
let g:go_def_mapping_enabled = 0

"------------------------------------------------------------------------------
" LEADER MAPPINGS
"------------------------------------------------------------------------------
"set leader
let mapleader = ","

" switch between files
nnoremap <leader><leader> <c-^>

" quickly Open vimrc
nmap <silent> <leader>ev :edit $MYVIMRC<cr>
" load vimrc into memory
nmap <silent> <leader>ee :source $MYVIMRC<cr>

nnoremap <leader>s :w<cr>
nnoremap <leader>q :x<cr>

" clear the search buffer when hitting <leader><space>
" <space> is being used by COC
nnoremap <leader><space> :nohlsearch<cr>

" reselect when indenting
vnoremap < <gv
vnoremap > >gv

" clipboard fusion!
"set clipboard^=unnamed clipboard^=unnamedplus

" turn folding on and open by default
set foldmethod=syntax
set foldlevel=99

" remove the need to hit c-w for navigating splits
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
set laststatus=2

" resize windows more easily
nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3)<CR>

" abbreviations
" ^M --> <Ctrl-V><CR>
iab tfunc func Test(t *testing.T){}<esc>3k2e
iab trun t.Run(,func(t *testing.T){})<esc>2ke
" Keeping this example of function call for future reference.
" iab tfunc <C-R>=Testabbr()<CR><esc>3k2e
" function! Testabbr()
"     return "func Test(t *testing.T){}"
" endfunction

