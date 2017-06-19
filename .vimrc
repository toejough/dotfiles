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
    " non-python completions - fs/buffer/etc
    Plug 'shougo/neocomplete.vim'
    " tab-completion of the above completions
    Plug 'ervandew/supertab'
    " fast comment toggling
    Plug 'scrooloose/nerdcommenter'
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
    " required settings
    set nocompatible
    set hidden
    " suggested setting - heavy use of tabs, so the tabline isn't the normal
    " tabline, so just stop showing it
    set showtabline=0
    " default key
    let CtrlSpaceDefaultMappingKey = "<leader> "


" leader key
let mapleader = ","

" jedi
    " change usages shortcut
    " it defaults to <leader>n, but I want to use that with NERDTree
    let jedi#usages_command = '<leader>u'
    " show signature inline
    let jedi#show_call_signatures = 2

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

" neocomplete
    " start up on startup
    let neocomplete#enable_at_startup = 1
    " automatically pre-select the first thing in the completion list
    let neocomplete#enable_auto_select = 1

" change current working directory for the local file when you switch buffers
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
autocmd BufEnter * silent! lcd %:p:h
