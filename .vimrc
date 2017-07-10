" Plugin management
call plug#begin()
    " Python highlighting/folding
    Plug 'klen/python-mode'
    " solarized color scheme
    Plug 'altercation/vim-colors-solarized'
    " fuzzy search
    Plug 'ctrlpvim/ctrlp.vim'
    " file navigation/manipulation
    Plug 'scrooloose/nerdtree'
    " python completion/goto/doc - better than python-mode
    Plug 'davidhalter/jedi-vim'
    " non-python completions - fs/buffer/etc
    " youcompleteme kept failing when I'd switch python environments
    " neocomplete was super slow on my home computer
    Plug 'ajh17/VimCompletesMe'
    " tab-completion of the above completions
    Plug 'ervandew/supertab'
    " fast comment toggling
    Plug 'scrooloose/nerdcommenter'
    " surround things with parens/quotes
    Plug 'tpope/vim-surround'
    " set and unset paste mode automatically
    Plug 'roxma/vim-paste-easy'
    " fish script syntax
    Plug 'dag/vim-fish'
    " Sweet undo history
    Plug 'mbbill/undotree'
    " Git helpers
    Plug 'tpope/vim-fugitive'
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

" supertab
    " return key closes the completion window without inserting newline
    let SuperTabCrMapping = 1
    " context-aware tab completion (filepath/function/text)
    let g:SuperTabDefaultCompletionType = "context"

" vim command/search case
set ignorecase

" vim backspace
    " backspace through eol, indentation, and the start of insert mode
    set backspace=indent,eol,start

" change current working directory for the local file when you switch buffers
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
autocmd BufEnter * silent! lcd %:p:h

" ctrl-p
    " make first ctlp search be in mru by default, then buffers, then files after that
    let g:ctrlp_types = ['mru', 'buf', 'fil']

" use system clipboard
set clipboard=unnamed

" enable mouse support
set mouse=a

" reload & clean & update
    " :JustReloadRC will just reload this RC file
    command! -bar JustReloadRC source ~/.vimrc
    " :ReloadRC will do all three
    command! ReloadRC JustReloadRC|PlugClean|PlugUpdate
