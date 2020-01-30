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
        " explicitly set js indentation
        autocmd FileType javascript setlocal ts=2 sts=2 sw=2
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
    set nocursorline
    " explicitly use fish in interactive mode to mimic normal terminal
    set shell=fish\ -i
    " highlight max line length
    set colorcolumn=120
    " use truecolor colors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    " stop all the "hit ENTER to continue" messages
    set cmdheight=2
    " use syntax folding by default
    set foldmethod=syntax
    " jump to last postion
    if has("autocmd")
      au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
    endif

" Plugin management
    " Install manager if not present
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
    endif
    " Load plugins
    call plug#begin()
        " solarized color scheme
        Plug 'lifepillar/vim-solarized8'
        " file navigation/manipulation
        Plug 'scrooloose/nerdtree'
        " tab-completion of the above completions
        " commented out for now for coc
        "Plug 'ervandew/supertab'
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
        " highlight everything during incremental search
        Plug 'haya14busa/incsearch.vim'
        " Whitespace stripping"
        Plug 'ntpeters/vim-better-whitespace'
        " Focus on the current text blob
        Plug 'junegunn/limelight.vim'
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
        Plug 'othree/yajs.vim'
        " class outline
        Plug 'majutsushi/tagbar'
        " fzf
        Plug '/usr/local/opt/fzf'
        Plug 'junegunn/fzf.vim'
        " set cwd to the git root
        Plug 'airblade/vim-rooter'
        " snippets
        Plug 'SirVer/ultisnips'
        " go refactoring
        Plug 'godoctor/godoctor.vim'
        " better git conflict resolution
        Plug 'christoomey/vim-conflicted'
        " better markdown folding
        Plug 'masukomi/vim-markdown-folding'
        " elm syntax
        Plug 'andys8/vim-elm-syntax'
        " rainbow parens
        Plug 'luochen1990/rainbow'
        " XML
        Plug 'othree/xml.vim'
        " language server protocol client
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        " vim elm snippets
        Plug 'honza/vim-snippets'
    call plug#end()

" solarized
    syntax enable
    set background=dark
    colorscheme solarized8

" nerdtree
    " toggle nerdtree with leader-n
    map <leader>t :NERDTreeFind<CR>
    " close the nerdtree when a file is opened from it
    let NERDTreeQuitOnOpen = 1

" commented out now for coc tab use
"" supertab
"    " return key closes the completion window without inserting newline
"    let SuperTabCrMapping = 1
"    " context-aware tab completion (filepath/function/text)
"    let g:SuperTabDefaultCompletionType = "context"
"    " chain completion to fall back to omnifunc if context completion doesn't
"    " work
"    autocmd FileType *
"    \ if &omnifunc != '' |
"    \   call SuperTabChain(&omnifunc, "<c-p>") |
"    \ endif

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
            \ 'conflicts': 'LightlineConflicts',
            \ 'lsp': 'coc#status',
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
    function! LightlineConflicts()
        let conflictVersion = ConflictedVersion()
        return conflictVersion !=# '' ? conflictVersion : ''
    endfunction
    function! DevIconFiletype()
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
    endfunction
    function! DevIconFileformat()
        return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
    endfunction
    let lightline.active = {
    \ 'left': [ [ 'mode', 'paste' ],
    \           [ 'readonly', 'filename', 'modified' ],
    \           [ 'lsp' ] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'fileformat', 'fileencoding', 'filetype' ],
    \            [ 'fugitive', 'conflicts' ],
    \          ] }
    let g:lightline.inactive = {
    \ 'left': [ [ 'filename' ] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'fugitive', 'conflicts' ] ] }
    " don't show mode, because lightline shows the mode
    set noshowmode
    " update lightline on coc status changes
    autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" comfortable motion (Scrolling)
    noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
    noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>

" incsearch
    " default search uses inc
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)

" Whitespace stripping
    autocmd BufEnter * EnableStripWhitespaceOnSave
    let g:strip_whitespace_confirm=0

" Focus on the current text blob
    let g:limelight_conceal_ctermfg = 'DarkGrey'
    autocmd VimEnter * Limelight
    nmap <Leader>L :Limelight!!<CR>

" Git gutter
    set signcolumn=yes
    set updatetime=100
    let g:gitgutter_highlight_lines = 1
    let g:gitgutter_highlight_linenrs = 1
    let g:gitgutter_preview_win_floating = 1
    " disable default key mappings
    let g:gitgutter_map_keys = 0
    " custom keymappings
    nmap <leader>hn <Plug>(GitGutterNextHunk)
    nmap <leader>hp <Plug>(GitGutterPrevHunk)
    nmap <leader>hs <Plug>(GitGutterStageHunk)
    nmap <leader>hu <Plug>(GitGutterUndoHunk)
    nmap <leader>hv <Plug>(GitGutterPreviewHunk)

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
    nmap s :Limelight!<CR><Plug>(easymotion-bd-fn)
    " Jump to anywhere in this line with only `s{char}{target}`
    nmap f <Plug>(easymotion-bd-fln)

" Markdown formatting
    let g:vim_markdown_fenced_languages = ['python=python']
    " folding fix from https://github.com/plasticboy/vim-markdown/issues/414#issuecomment-519061229
    let g:vim_markdown_folding_style_pythonic = 1
    " even that was insufficient and had weird behavior in some files
    let g:vim_markdown_folding_disabled = 1
    " use the auto-folding from vim-markdown-folding
    autocmd FileType markdown set foldexpr=NestedMarkdownFolds()

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
    let g:go_metalinter_autosave = 0
    let g:go_fmt_autosave = 0
    let g:go_guru_scope = ['./...']
    let g:go_doc_popup_window = 1
    " hold off till gopls 0.4.0: https://github.com/fatih/vim-go/issues/2710
    "let g:go_auto_type_info = 1
    "let g:go_auto_sameids = 1
    let g:go_rename_command = 'gopls'
    " clobbered the easymotion binding for K
    let g:go_doc_keywordprg_enabled = 0
    let g:go_gopls_use_placeholders = 1
    let g:go_gopls_complete_unimported = 1
    let g:go_gopls_deep_completion = 1
    let g:go_gopls_fuzzy_matching = 1
    let g:go_diagnostics_enabled = 1
    " all output goes into the location list
    let g:go_list_type = "locationlist"
    nmap <leader>ga <Plug>(go-alternate-edit)
    nmap <leader>gc <Plug>(go-callstack)
    nmap <leader>gd <Plug>(go-describe)
    nmap <leader>gf <Plug>(go-imports)
    nmap <leader>gg <Plug>(go-generate)
    nmap <leader>gi <Plug>(go-implements)
    nmap <leader>gm :GoImpl<CR>
    nmap <leader>gn <Plug>(go-rename)
    nmap <leader>gr <Plug>(go-referrers)

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
    " config from https://github.com/elm-tooling/elm-vim#tagbar
    let g:tagbar_type_elm = {
    \ 'kinds' : [
    \ 'f:function:0:0',
    \ 'm:modules:0:0',
    \ 'i:imports:1:0',
    \ 't:types:1:0',
    \ 'a:type aliases:0:0',
    \ 'c:type constructors:0:0',
    \ 'p:ports:0:0',
    \ 's:functions:0:0',
    \ ]
    \}
    nmap <leader>T :Tagbar<CR>

" fzf
    let g:fzf_history_dir = '~/.local/share/fzf-history'
    let g:fzf_layout = { 'window': 'enew' }

    nnoremap <leader>fa :Ag<CR>
    nnoremap <leader>fb :Buffers<CR>
    nnoremap <leader>ff :GFiles<CR>
    nnoremap <leader>fL :Lines<CR>
    nnoremap <leader>fm :Maps<CR>
    nnoremap <leader>fl :BLines<CR>
    nnoremap <leader>fh :History<CR>
    nnoremap <leader>fs :Snippets<CR>
    " launch fzf if vim is opened without a file
    function! IfEmpty()
        if @% == ""
            History
        endif
    endfunction
    au VimEnter * call IfEmpty()

" vim-rooter
    let g:rooter_manual_only = 1
    " change current working directory for the local file when you switch buffers
    " http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
    nnoremap <leader>dc :lcd %:p:h<cr>
    nnoremap <leader>dr :Rooter<cr>

" ultisnips
    " make work with supertab: https://github.com/SirVer/ultisnips/issues/376#issuecomment-69033351
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<shift-tab>"
    let g:UltiSnipsExpandTrigger="<nop>"
    let g:ulti_expand_or_jump_res = 0
    function! <SID>ExpandSnippetOrReturn()
      let snippet = UltiSnips#ExpandSnippetOrJump()
      if g:ulti_expand_or_jump_res > 0
        return snippet
      else
        return "\<CR>"
      endif
    endfunction
    inoremap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"
    let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/dotfiles/snippets"]

" Rainbow parens
    let g:rainbow_active = 1

" COC
    " Set hidden?
    " from the help: When off a buffer is unloaded when it is abandoned
    " from coc: if hidden is not set, TextEdit might fail.
    " presumably coc uses hidden buffers for some source edits?
    set hidden
    " no backups.  default off, but this makes it explicit
    set nobackup
    set nowritebackup
    " a faster update time
    set updatetime=300
    " don't give ins-completion-menu messages
    set shortmess+=c
    " always show the sign column
    set signcolumn=yes
    " coc wants to control tab completion...
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

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " Or use `complete_info` if your vim support it, like:
    " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> <leader>ld :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')
    " Remap for rename current word
    nmap <leader>lr <Plug>(coc-rename)
    " Remap for format selected region
    xmap <leader>lf  <Plug>(coc-format-selected)
    nmap <leader>lf  <Plug>(coc-format-selected)

    augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap for do codeAction of current line
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Create mappings for function text object, requires document symbols feature of languageserver.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    " Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
    nmap <silent> <TAB> <Plug>(coc-range-select)
    xmap <silent> <TAB> <Plug>(coc-range-select)

    " Use `:Format` to format current buffer
    command! -nargs=0 Format :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <leader>lld  :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent> <leader>lle  :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <leader>llc  :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <leader>llo  :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent> <leader>lls  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <leader>lj  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <leader>lk  :<C-u>CocPrev<CR>
    " Resume latest coc list
    nnoremap <silent> <leader>llr  :<C-u>CocListResume<CR>

" Custom key mappings and commands
" (set here to avoid plugin overrides)
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
        command! ReloadRC JustReloadRC|PlugClean|PlugUpdate|UpdateRemotePlugins|JustReloadRC
    " insert a date when typing 'dts'
    iab <expr> dts strftime("%F %T%z")
    " exit on ctrl-q
    nnoremap <C-q> :q<cr>
    inoremap <C-q> <Esc>:q<cr>
    " search visual selection
    vnoremap // y/\M<C-R>"<CR>
    " replace visual selection
    vnoremap ss y:%s/\M<C-R>"/
    " location list jumping
    nnoremap <leader>ln :lne<cr>
    nnoremap <leader>lp :lpre<cr>
    " quickfix list jumping
    nnoremap <leader>qn :cne<cr>
    nnoremap <leader>qp :cpre<cr>
