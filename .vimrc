" Plugin management
call plug#begin()
    " Python highlighting/folding
    Plug 'klen/python-mode'
    " specific commands for copy/paste to system clipboard
    Plug 'christoomey/vim-system-copy'
    " solarized color scheme
    Plug 'altercation/vim-colors-solarized'
    " fuzzy search
    Plug 'vim-ctrlspace/vim-ctrlspace'
    " file navigation/manipulation
    Plug 'scrooloose/nerdtree'
    " python completion/goto/doc - better than python-mode
    Plug 'davidhalter/jedi-vim'
call plug#end()

" python-mode config
    " color-column
    let pymode_options_max_line_length = 120
    " no linting - just do that externally
    let pymode_lint = 0
    " turn off rope support
    let pymode_rope = 0

" solarized
syntax enable
set background=dark
colorscheme solarized

" Ctrl-space
set nocompatible
set hidden
set showtabline=0

" leader key
let mapleader = ","

" jedi
    " change usages shortcut
    " it defaults to <leader>n, but I want to use that with NERDTree
    let jedi#usages_command = '<leader>u'

" nerdtree
    " toggle nerdtree with leader-n
    map <leader>n :NERDTreeFind<CR>
    " close the nerdtree when a file is opened from it  
    let NERDTreeQuitOnOpen = 1 

" tabs
    " use filetype-specific indentation, if that's set up in plugins
    filetype plugin indent on
    " show existing tab with 4 spaces width
    set tabstop=4
    " when indenting with '>', use 4 spaces width
    set shiftwidth=4
    " On pressing tab, insert 4 spaces
    set expandtab

" vim command/search case
set ignorecase

" vim backspace
    " backspace through eol, indentation, and the start of insert mode
    set backspace=indent,eol,start
