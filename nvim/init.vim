scriptencoding=utf-8
" ------------------------------- PLUGIN SECTION ------------------------------
" Auto download VimPlug if not available
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

" ############## Python support ##########

" Don't forget to run :PythonSupportInitPython3
" Python modules manager
Plug 'roxma/python-support.nvim'
let g:python_support_python2_require=0

" for python completions
let g:python_support_python3_requirements =
        \ add(get(g:,'python_support_python3_requirements',[]),'jedi')
" language specific completions on markdown file
let g:python_support_python3_requirements =
        \ add(get(g:,'python_support_python3_requirements',[]),'mistune')
" utils, optional
let g:python_support_python3_requirements =
        \ add(get(g:,'python_support_python3_requirements',[]),'psutil')
let g:python_support_python3_requirements =
        \ add(get(g:,'python_support_python3_requirements',[]),'setproctitle')

" ########################################

" Themes
let s:active_theme='gruvbox'

if s:active_theme ==? 'gruvbox'
    " Gruvbox
    Plug 'morhetz/gruvbox'
    let g:gruvbox_contrast_dark ='medium'
    let g:gruvbox_contrast_light='hard'
    let g:gruvbox_inverse='1'
    let g:gruvbox_italic='1'
elseif s:active_theme ==? 'nord'
    " Nord
    Plug 'arcticicestudio/nord-vim'
    let g:nord_italic=1
    let g:nord_underline=1
    let g:nord_cursor_line_number_background=1
    let g:nord_comment_brightness=10
end

" LightLine
Plug 'itchyny/lightline.vim'
let g:lightline={
        \ 'colorscheme': s:active_theme,
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'spell', 'gitbranch', 'readonly', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'spell'    : 'LightlineSpell',
        \   'gitbranch': 'fugitive#head',
        \   'filename' : 'LightlineFilename',
        \   'mode'     : 'LightlineMode',
        \ },
        \ }

" VimWiki
Plug 'vimwiki/vimwiki'
" let g:vimwiki_list = [{
"         \ 'syntax': 'markdown',
"         \ 'ext'   : '.md'
"         \}]

" Session manager
Plug 'tpope/vim-obsession'

" Auto close tags
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'tpope/vim-unimpaired'

" Comments
Plug 'tpope/vim-commentary'

" Align characters
Plug 'tommcdo/vim-lion'

" Additional vim motion targets
Plug 'wellle/targets.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
let g:fugitive_gitlab_domains = ['https://gitlab.inria.fr/']

"############### Languages ###############
" Markdown
Plug 'plasticboy/vim-markdown'
" GLSL
Plug 'tikhomirov/vim-glsl'
" Latex
" Plug 'vim-latex/vim-latex'
" Qt
" Plug 'peterhoeg/vim-qml'

" ############## Auto Completion #########
" FZF (requires fzf installed globally)
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
nnoremap <leader>f :FZF<CR>
" LSP
Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do'    : 'make release',
        \ }
" \ 'do': 'bash install.sh', " Download binary
let g:LanguageClient_serverCommands={
        \ 'rust'  : ['rustup', 'run', 'stable', 'rls'],
        \ 'python': ['pyls'],
        \ 'c'     : ['ccls'],
        \ 'cpp'   : ['ccls'],
        \ }

function! SetLSPShortcuts()
    nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
    nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
    nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
    nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
    nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
    nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
    nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
    nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
    nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
endfunction()

augroup LSP
    autocmd!
    autocmd FileType cpp,c,rust,python call SetLSPShortcuts()
    autocmd User LanguageClientStarted setlocal signcolumn=yes
    autocmd User LanguageClientStopped setlocal signcolumn=auto
augroup END

" Deoplete
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

let g:deoplete#enable_at_startup=1
" call deoplete#custom#source('LanguageClient',
"         \ 'min_pattern_length',
"         \ 2)

Plug 'Shougo/echodoc.vim'
set cmdheight=2
let g:echodoc#enable_at_startup=1
let g:echodoc#type='signature'

" Snippets
Plug 'SirVer/ultisnips'
let g:UltiSnipsEditSplit='context'
let g:UltiSnipsExpandTrigger='<c-j>'
Plug 'honza/vim-snippets'
Plug 'niverton/niv-snippets'

"Plug 'aurieh/discord.nvim', { 'do': ':UpdateRemotePlugins'}

call plug#end()

" -------------------------------- COLORSCHEME --------------------------------

""Set the background according to time of day
"let time=str2nr(system('date +%-H'))
"if time >= 18 || time < 8
"  set background=dark
"else
"  set background=light
"endif
"unlet time

set background=dark

" Enable true color support
set termguicolors
execute 'colorscheme ' . s:active_theme

" ---------------------------------- SETTINGS ---------------------------------

" Disable default rustmode 'style preference' (tw=99, sw=4)
let g:rust_recommended_style=0

" Unmap space for use as leader
nnoremap <Space> <nop>
let g:mapleader="\<Space>"
set tabstop=8                 " Tab size
set shiftwidth=4              " Indent size
set expandtab                 " Use spaces instead of tabs
set number                    " Display line numbers
set textwidth=80              " Line wrap
set cursorline                " highlight cursor line
set mouse=a                   " Full mouse support
filetype indent on
set lazyredraw                " Redraw screen only when needed
set noshowmode                " Hide mode in echo bar
set showmatch                 " Highlight pairs
set noequalalways             " Don't resize all windows when layout changes
set diffopt+=vertical

" Terminal mode settings
augroup TERM
    function! TermEnter()
        if &buftype ==# 'terminal'
            startinsert
        endif
    endfunction

    autocmd TermOpen * setlocal nonumber
    autocmd TermOpen * setlocal nocursorline
    autocmd TermOpen * startinsert
    autocmd BufEnter * call TermEnter()
augroup end


" hightlight whitespaces

highlight! link ExtraWhitespace Error
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

command! TrimWhiteSpace call TrimWhiteSpace()

" ----------------------------------- SEARCH ----------------------------------

set ignorecase
set smartcase
set incsearch                 " Search when typing
set hlsearch

" Ripgrep
if executable('rg')
    set grepprg=rg\ -n
endif

" ---------------------------------- FOLDING ----------------------------------

set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax
"Toggle fold
"nnoremap <space> za


" -------------------------------- SPELL CHECK --------------------------------

" TODO fix this, investigate
highlight clear SpellBad
highlight SpellBad cterm=underline
command! SpellCheckEng :setlocal spell spelllang=en
command! SpellCheckFra :setlocal spell spelllang=fr

" ----------------------------- FUZZY FILE SEARCH -----------------------------

set path+=**
set wildmenu
set wildignorecase
" ignore these files when completing names and in Ex
set wildignore=build,release,debug,.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam
" set of file name suffixes that will be given a lower priority when
" it comes to matching wildcards
set suffixes+=.old*

" -------------------------------- NETRW CONFIG -------------------------------

let g:netrw_browse_split=0          " open in current window
let g:netrw_altv=1                  " open splits to the right
let g:netrw_liststyle=3             " tree view

" ----------------------------------- REMAPS ----------------------------------

"Insert new line
nmap <leader>O O<Esc>j
nmap <leader>o o<Esc>k

nnoremap j gj
nnoremap k gk
" Make
"nnoremap <leader>m :make<CR>

"List buffers and prompt
nnoremap <leader>b :ls<CR>:buffer 
"List tabs and switch
nnoremap <leader>v :tabs<CR>:tabnext 

" Nohl && close preview window
nnoremap <leader><leader> :pclose<CR>:let @/ = ""<CR>

" Normal mode from terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

" Replace all occurences of word under cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
" Navigate buffers quickly
nnoremap <C-q> :bnext<CR>
nnoremap <C-s> :bprevious<CR>

" ------------------------------ CUSTOM FUNCTIONS -----------------------------

" Lightline
function! LightlineFilename()
    let filename=expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
    let modified=&modified ? '+' : ''
    return filename . modified
endfunction

function! LightlineMode()
    return &filetype ==# 'gitcommit' ? 'Git' :
                \lightline#mode()
endfunction

function! LightlineSpell()
    if (empty(&spell))
        return ''
    else
        return 'SPELL ' . &spelllang
    endif
endfunction
