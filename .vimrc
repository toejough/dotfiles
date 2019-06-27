" Non-plugin customizations
    " vi compatibility
    set nocompatible
    " no swapfile
    let updatecount=0
    set noswapfile
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
    " enable mouse support in tmux/screen
    " (https://superuser.com/questions/549930/cant-resize-vim-splits-inside-tmux)
    if &term =~ '^screen'
        " tmux knows the extended mouse mode
        set ttymouse=xterm2
    endif
    " When a file has been detected to have been changed outside of Vim and
	" it has not been changed inside of Vim, automatically read it again.
    set autoread
    " lines of context when moving
    set so=10
    " line numbers
    set number
    " persistent undo
    if has("persistent_undo")
        silent !mkdir -p ~/.vimundo
        set undodir=~/.vimundo/
        set undofile
    endif
    " use smartcase
    set smartcase
    " try to speed things up
    set lazyredraw
    set ttyfast
    " explicitly use fish in interactive mode to mimic normal terminal
    set shell=fish\ -i
    " highlight max line length (flake8 says 79, so mark 80)
    set colorcolumn=80
    " use truecolor colors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors

" Plugin management
    " Install manager if not present
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
    endif
    " Load plugins
    call plug#begin()
        " Python
            " python completion/goto/doc - better than python-mode
            "Plug 'davidhalter/jedi-vim', { 'tag': '0.9.0' }
            Plug 'davidhalter/jedi-vim'
            " jedi-vim better than pymode for completion, but both together
            " made things slow. this module is for just highlighting
            Plug 'vim-python/python-syntax'
            " Folding
            Plug 'tmhedberg/SimpylFold'
            " Indentation
            "Plug 'blueyed/vim-python-pep8-indent', { 'commit': 'efa7e6b0ee1448f98f5a359fe2b6a9b330434db7' }
            Plug 'Vimjas/vim-python-pep8-indent'
        " solarized color scheme
        Plug 'lifepillar/vim-solarized8'
        " fuzzy search
        Plug 'ctrlpvim/ctrlp.vim'
        " file navigation/manipulation
        Plug 'scrooloose/nerdtree'
        " non-python completions - fs/buffer/etc
        " youcompleteme kept failing when I'd switch python environments
        Plug 'Shougo/neocomplete.vim'
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
        " nice icons for file paths
        Plug 'ryanoasis/vim-devicons'
        " simple statusline
        Plug 'itchyny/lightline.vim'
        " smoother scrolling
        Plug 'yuttie/comfortable-motion.vim'
        " faster/better search
        Plug 'mileszs/ack.vim'
        " highlight everything during incremental search
        Plug 'haya14busa/incsearch.vim'
        " Whitespace stripping"
        Plug 'ntpeters/vim-better-whitespace'
        " Focus on the current text blob
        Plug 'junegunn/limelight.vim'
        " Rainbow parens
        Plug 'junegunn/rainbow_parentheses.vim'
        " clear hl after search
        Plug 'junegunn/vim-slash'
        " Git marks, staging hunks
        Plug 'airblade/vim-gitgutter'
        " git browser
        Plug 'junegunn/gv.vim'
        " better auto read - doesn't require buffer change
        Plug 'djoshea/vim-autoread'
        " Toml support
        Plug 'cespare/vim-toml'
        " Ponylang support
        "Plug 'dleonard0/pony-vim-syntax'
        " Camelcase motions with <leader>w,b,e, etc
        Plug 'bkad/camelcasemotion'
        " Ctrl-n to select things
        Plug 'terryma/vim-multiple-cursors'
        " Better inc/dec for dates
        Plug 'tpope/vim-speeddating'
        " Repeat semantics for more things
        Plug 'tpope/vim-repeat'
        " Change cases and more (camel-case with crc, snake with crs)
        Plug 'tpope/vim-abolish'
        " faster/fuzzier searching in buffers
        Plug 'easymotion/vim-easymotion'
        " markdown preview
        Plug 'shime/vim-livedown'
        " markdown formatting
        Plug 'plasticboy/vim-markdown'
        " indent guides
        Plug 'nathanaelkane/vim-indent-guides'
        " aligning text
        Plug 'godlygeek/tabular'
        " autosave
        Plug '907th/vim-auto-save'
        " go
        Plug 'fatih/vim-go'
        " html
        Plug 'othree/html5.vim'
        Plug 'alvan/vim-closetag'
        " javascript
        Plug 'pangloss/vim-javascript'
        " class outline
        Plug 'majutsushi/tagbar'
    call plug#end()

" jedi
    " change usages shortcut
    " it defaults to <leader>n, but I want to use that with NERDTree
    let jedi#usages_command = '<leader>z'
    " show signature inline
    let jedi#show_call_signatures = 2
    " doc
    let jedi#documentation_command = '<leader>d'

" python-syntax
    let python_highlight_all = 1
    let python_slow_sync = 0

" solarized
    syntax enable
    set background=dark
    colorscheme solarized8

" ctrl-p
    " make first ctlp search be in mru by default, then buffers, then files after that
    let g:ctrlp_types = ['mru', 'buf', 'fil']
    " launch ctrl-p if vim is opened without a file
    function! CtrlpIfEmpty()
        if @% == ""
            CtrlP
        endif
    endfunction
    au VimEnter * call CtrlpIfEmpty()

" nerdtree
    " toggle nerdtree with leader-n
    map <leader>t :NERDTreeFind<CR>
    " close the nerdtree when a file is opened from it
    let NERDTreeQuitOnOpen = 1

" elm completions with neocomplete
    "call neocomplete#util#set_default_dictionary(
    "    \ 'g:neocomplete#sources#omni#input_patterns',
    "    \ 'elm',
    "    \ '\.')

" supertab
    " return key closes the completion window without inserting newline
    let SuperTabCrMapping = 1
    " context-aware tab completion (filepath/function/text)
    let g:SuperTabDefaultCompletionType = "context"
    " chain completion to fall back to omnifunc if context completion doesn't
    " work
    autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-p>") |
    \ endif

" undotree
    nnoremap <leader>u :UndotreeToggle<cr>

" devicons
    " expects that a nerdfont was installed, such as from
    " `brew tap Caskroom/fonts; and brew cask install
    " font-sourcecodepro-nerd-font`
    if empty(system('brew cask list | grep sourcecodepro'))
        silent !brew tap Caskroom/fonts; brew cask install font-sourcecodepro-nerd-font
    endif

" lightline
    " show the line
    set laststatus=2
    " set extra config
    let lightline = {
        \ 'colorscheme': 'solarized',
        \ 'component': {
            \ 'lineinfo': ' %3l:%-2v',
        \ },
        \ 'component_function': {
            \ 'filetype': 'DevIconFiletype',
            \ 'fileformat': 'DevIconFileformat',
            \ 'readonly': 'LightlineReadonly',
            \ 'fugitive': 'LightlineFugitive',
        \ },
    \ 'separator': { 'left': "\ue0b4", 'right': "\ue0b6" },
    \ 'subseparator': { 'left': "\ue0b5", 'right': "\ue0b7" },
    \ }
    function! LightlineReadonly()
        return &readonly ? '' : ''
    endfunction
    function! LightlineFugitive()
        if exists('*fugitive#head')
            let branch = fugitive#head()
            return branch !=# '' ? ''.branch : ''
        endif
        return ''
    endfunction
    function! DevIconFiletype()
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
    endfunction
    function! DevIconFileformat()
        return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
    endfunction
    " don't show mode, because lightline shows the mode
    set noshowmode

" comfortable motion (Scrolling)
    noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
    noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>

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
    " default search uses inc
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)

" Whitespace stripping
    autocmd BufEnter * EnableStripWhitespaceOnSave
    let g:strip_whitespace_confirm=0

" Focus on the current text blob
    let g:limelight_conceal_ctermfg = 'DarkGrey'
    autocmd VimEnter * Limelight

" Rainbow parens
    let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
    autocmd BufEnter * RainbowParentheses

" Git gutter
    set signcolumn=yes
    set updatetime=100

" CamelCase keys
    call camelcasemotion#CreateMotionMappings('<leader>')

" Easy motion
    " jk motions: up/down lines
    nmap J <Plug>(easymotion-j)
    nmap K <Plug>(easymotion-k)
    vmap J <Plug>(easymotion-j)
    vmap K <Plug>(easymotion-k)
    " lh motions: right/left in line
    nmap L <Plug>(easymotion-lineforward)
    nmap H <Plug>(easymotion-linebackward)
    vmap L <Plug>(easymotion-lineforward)
    vmap H <Plug>(easymotion-linebackward)
    " Jump to anywhere with only `s{char}{target}`
    nmap s <Plug>(easymotion-bd-fn)
    " Jump to anywhere in this line with only `s{char}{target}`
    nmap f <Plug>(easymotion-bd-fln)

" Markdown formatting
    let g:vim_markdown_fenced_languages = ['python=python']

" Indent guide colors
    let g:indent_guides_auto_colors = 0
    let g:indent_guides_enable_on_vim_startup = 1
    hi IndentGuidesEven ctermbg=Black

" Livedown
    if !executable('node')
        silent !brew install node
    endif
    if !executable('livedown')
        silent !npm install -g livedown

    endif
    nmap gm :LivedownToggle<CR>

" Autosave
    let g:auto_save = 1  "

" vim-go
    " fixup for undo issue (https://github.com/fatih/vim-go/issues/1134)
    let g:go_fmt_experimental = 1
    let g:go_metalinter_command = "golangci-lint run"
    let g:go_jump_to_error = 0
    let g:go_metalinter_autosave = 1
    let g:go_list_type = "locationlist"

" tagbar
" config from https://github.com/jstemmer/gotags
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" Custom key mappings and commands
" (set here to avoid plugin overrides)
    " insert python breakpoint on <leader>p
    noremap <leader>p Oimport bpdb; bpdb.set_trace()<esc>
    " folds
        " <space> opens a fold as long as there's a closed fold under it
        " otherwise closes one fold level
        noremap <space> za
        " unfold down to the current line, refold everything else
        noremap <leader><space> zxzz
    " retain visual selection after indentation
    vnoremap > >gv
    vnoremap < <gv
    " always move up/down a displayed row, instead of
    " by line (different when lines wrap)
    noremap j gj
    noremap k gk
    " reload & clean & update
        " :JustReloadRC will just reload this RC file
        command! -bar JustReloadRC source ~/.vimrc
        " :ReloadRC will do all three
        command! ReloadRC JustReloadRC|PlugClean|PlugUpdate|JustReloadRC
    " insert a date when typing 'dts'
    iab <expr> dts strftime("%F %T%z")
    " exit on ctrl-q
    nnoremap <C-q> :q<cr>
    inoremap <C-q> <Esc>:q<cr>
    " search visual selection
    vnoremap // y/\M<C-R>"<CR>
    " replace visual selection
    vnoremap ss y:%s/\M<C-R>"/
