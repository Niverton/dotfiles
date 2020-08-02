scriptencoding=utf-8

" Unmap space to use as leader
nnoremap <Space> <nop>
let g:mapleader="\<Space>"

" ------------------------------- PLUGIN SECTION ------------------------------
" Auto download VimPlug if not available
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    augroup VimPlug
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
endif

call plug#begin('~/.local/share/nvim/plugged')

" ############## Python support ##########

" Don't forget to run :PythonSupportInitPython3
" Python modules manager
Plug 'roxma/python-support.nvim'
let g:python_support_python2_require=0

" ########################################

" Themes
let s:active_theme='gruvbox'

if s:active_theme ==? 'gruvbox'
    " Gruvbox
    Plug 'gruvbox-community/gruvbox'
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
        \       'left': [ [ 'mode', 'paste' ],
        \               [ 'spell', 'gitbranch', 'readonly', 'filename' ] ],
        \       'right': [ ['linenum'],
        \               ['filetype'],
        \               ['fileencoding'] ],
        \ },
        \ 'component': {
        \       'linenum': '%l/%L:%c',
        \ },
        \ 'component_function': {
        \       'spell'          : 'LightlineSpell',
        \       'gitbranch'      : 'fugitive#head',
        \       'filename'       : 'LightlineFilename',
        \       'mode'           : 'LightlineMode',
        \ },
        \ }
" Display code context at the top
Plug 'wellle/context.vim'

" VimWiki
Plug 'vimwiki/vimwiki'

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

" Abolish
Plug 'tpope/vim-abolish'

" Align characters
Plug 'tommcdo/vim-lion'

" Additional vim motion targets
Plug 'wellle/targets.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'

"############### Languages ###############
" Markdown
Plug 'plasticboy/vim-markdown'
" GLSL
Plug 'tikhomirov/vim-glsl'

" ############## Auto Completion #########

" Nvim LSP
if has('nvim-0.5.0')
    Plug 'neovim/nvim-lsp'
endif

" ################ Fuzzy ################
if executable('sk')
    Plug 'lotabout/skim.vim'

    nnoremap <silent> <leader>b :Buffers<CR>
    nnoremap <silent> <leader>f :Files<CR>

    command! -bang -nargs=* Ag call fzf#vim#ag_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))
    command! -bang -nargs=* Rg call fzf#vim#rg_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))
endif

call plug#end()

" -------------------------------- LSP confing --------------------------------

if has('nvim-0.5.0')
    " Mappings
    nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> <leader>d <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    nnoremap <silent> <leader>g <cmd>lua vim.lsp.buf.formatting()<CR>

    " Languages
    " Rust
    autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc

lua << EOF
local nvim_lsp = require('nvim_lsp')
nvim_lsp.rust_analyzer.setup({})
EOF
endif

" -------------------------------- COLORSCHEME --------------------------------

set background=dark

" Enable true color support
set termguicolors
execute 'colorscheme ' . s:active_theme

" ---------------------------------- SETTINGS ---------------------------------

" Disable default rustmode 'style preference' (tw=99, sw=4)
let g:rust_recommended_style=0

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
set splitbelow
set splitright

set hidden
set cmdheight=2

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
augroup WHITESPACE
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
augroup END

function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

command! TrimWhiteSpace call TrimWhiteSpace()

" ----------------------------------- SEARCH ----------------------------------

set ignorecase
set smartcase
set incsearch   " Search when typing
set hlsearch

" Ripgrep
if executable('rg')
    set grepprg=rg\ --vimgrep
endif

" ---------------------------------- FOLDING ----------------------------------

set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax

" -------------------------------- SPELL CHECK --------------------------------

" highlight clear SpellBad
" highlight SpellBad cterm=underline
command! SpellCheckEng :setlocal spell spelllang=en
command! SpellCheckFra :setlocal spell spelllang=fr

" -------------------------------- FILE SEARCH --------------------------------

set wildmenu
set wildignorecase
" ignore these files when completing names and in Ex
set wildignore=build,release,debug,.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam
" set of file name suffixes that will be given a lower priority when it comes to
" matching wildcards
set suffixes+=.old*

" -------------------------------- NETRW CONFIG -------------------------------

let g:netrw_browse_split=0          " open in current window
let g:netrw_altv=1                  " open splits to the right
let g:netrw_liststyle=3             " tree view

" ----------------------------------- REMAPS ----------------------------------

"Insert new line
nmap <leader>O O<Esc>j
nmap <leader>o o<Esc>k

noremap j gj
noremap k gk

" Clear search && close preview window
nnoremap <silent> <leader><leader> :pclose<CR>:let @/ = ""<CR>

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

" ------------------------------ CUSTOM FUNCTIONS -----------------------------

" Lightline
function! LightlineFilename()
    let filename=expand('%') !=# '' ? fnamemodify(expand('%'), ':~:.') : '[No Name]'
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

