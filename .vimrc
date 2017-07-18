" Non-plugin customizations
    " vi compatibility
    set nocompatible
    " no swapfile
    let updatecount=0
    " leader key
    let mapleader = ","
    " vim command/search case
    set ignorecase
    " incremental search highlighting
    set incsearch
    " tabs
        " use filetype-specific indentation, if that's set up in plugins
        filetype plugin indent on
        " show existing tab with 4 spaces width
        set tabstop=4
        " when indenting with '>', use 4 spaces width
        set shiftwidth=4
        " On pressing tab, insert 4 spaces
        set expandtab
    " backspace through eol, indentation, and the start of insert mode
    set backspace=indent,eol,start
    " change current working directory for the local file when you switch buffers
    " http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
    autocmd BufEnter * silent! lcd %:p:h
    " use system clipboard
    set clipboard=unnamed
    " enable mouse support
    set mouse=a
    " When a file has been detected to have been changed outside of Vim and
	" it has not been changed inside of Vim, automatically read it again.
    set autoread
    " reload & clean & update
        " :JustReloadRC will just reload this RC file
        command! -bar JustReloadRC source ~/.vimrc
        " :ReloadRC will do all three
        command! ReloadRC JustReloadRC|PlugClean|PlugUpdate
    " <space> opens a fold as long as there's a closed fold under it
    " otherwise closes one fold level
    noremap <space> za
    " unfold down to the current line, refold everything else
    noremap <leader><space> zxzz

" Plugin management
    " Install manager if not present
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
    endif
    " Load plugins
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
        " simple statusline
        Plug 'itchyny/lightline.vim'
        " nice icons for file paths
        Plug 'ryanoasis/vim-devicons'
        " smoother scrolling
        Plug 'yuttie/comfortable-motion.vim'
        " faster/better search
        Plug 'mileszs/ack.vim'
        " highlight everything during incremental search
        Plug 'haya14busa/incsearch.vim'
    call plug#end()

" python-mode config
    " color-column
    let pymode_options_max_line_length = 120
    " no linting - just do that externally
    let pymode_lint = 0
    " no completion - do that with jedi exclusively
    let pymode_rope_completion = 0
    " debugger command
    let pymode_breakpoint_cmd = 'import bpdb; bpdb.set_trace()  # XXX BREAKPOINT'

" solarized
    syntax enable
    set background=dark
    colorscheme solarized

" ctrl-p
    " make first ctlp search be in mru by default, then buffers, then files after that
    let g:ctrlp_types = ['mru', 'buf', 'fil']

" nerdtree
    " toggle nerdtree with leader-n
    map <leader>n :NERDTreeFind<CR>
    " close the nerdtree when a file is opened from it  
    let NERDTreeQuitOnOpen = 1 

" jedi
    " change usages shortcut
    " it defaults to <leader>n, but I want to use that with NERDTree
    let jedi#usages_command = '<leader>u'
    " show signature inline
    let jedi#show_call_signatures = 2

" supertab
    " return key closes the completion window without inserting newline
    let SuperTabCrMapping = 1
    " context-aware tab completion (filepath/function/text)
    let g:SuperTabDefaultCompletionType = "context"

" lightline
    " show the line
    set laststatus=2
    " set the colorscheme
    let lightline = { 
        \ 'colorscheme': 'solarized',
        \ 'component_function': {
            \ 'filetype': 'DevIconFiletype',
            \ 'fileformat': 'DevIconFileformat',
        \ }
    \ }
    function! DevIconFiletype()
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
    endfunction
    function! DevIconFileformat()
        return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
    endfunction
    " don't show mode, because lightline shows the mode
    set noshowmode 

" devicons
    " expects that a nerdfont was installed, such as from
    " `brew tap Caskroom/fonts; and brew cask install
    " font-sourcecodepro-nerd-font`
    if empty(system('brew cask list | grep sourcecodepro'))
        silent !brew tap Caskroom/fonts; brew cask install font-sourcecodepro-nerd-font 
    endif

" ack
    " search from the project root
    cnoreabbrev ag Gcd <bar> Ack!
    " use ag
    if !executable('ag')
        silent !brew install ag
    endif
    " depends on ag being installed via `brew install ag`, for instance
    let g:ackprg = "ag --vimgrep"
    " highlight results
    let g:ackhighlight = 1
    " don't close when a match is selected
    " this is a tempting default, but it also closes when you do a preview,
    " because the preview selects a match and jumps back down
    let g:ack_autoclose = 0
    " don't fold matches to the same file
    " this seems cool, but then you see
    " https://github.com/mileszs/ack.vim/issues/146, which means the
    " folds apply to all files, not just the quickfix window
    let g:ack_autofold_results = 0
    " don't use a preview window
    " it didn't open my folds, so it wasn't useful
    let g:ackpreview = 0
    " make the 'o' key jump to the match, fold everything but the current line, 
    " center the screen, then jump back down into the quickfix window.
    " If it's the one you want, hit q to exit quickfix and land back 
    " on the match.
    let g:ack_mappings = { "o": "<CR>zxzz<C-W>j" }
    " search word under cursor with <leader>a
    map <leader>a :ag<CR>

" incsearch
    " mappings
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
