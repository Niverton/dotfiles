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
        autocmd!
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
endif

let s:vimpluggedpath='~/.local/share/nvim/plugged'
call plug#begin(s:vimpluggedpath)

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
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_contrast_light='hard'
    let g:gruvbox_inverse='1'
    let g:gruvbox_italic='1'
    Plug 'gruvbox-community/gruvbox'
elseif s:active_theme ==? 'nord'
    " Nord
    let g:nord_italic=1
    let g:nord_underline=1
    let g:nord_cursor_line_number_background=1
    let g:nord_comment_brightness=10
    Plug 'arcticicestudio/nord-vim'
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
augroup LightlineColorscheme
    autocmd!
    autocmd ColorScheme * call s:lightline_update()
augroup END
function! s:lightline_update()
    if !exists('g:loaded_lightline')
        return
    endif
    if g:colors_name ==# 'gruvbox'
        " Reload gruvbox lightline plugin to set colors with new background
        " Use execute to only call 'runtime' when the function is called, not
        " when it is read...
        execute 'runtime' "/autoload/lightline/colorscheme/gruvbox.vim"
    elseif g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow'
        let g:lightline.colorscheme =
                    \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
    endif
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction
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
    Plug 'RishabhRD/popfix'
    Plug 'RishabhRD/nvim-lsputils'
endif

" ############ Tree-Sitter ##############
let s:use_tree_sitter=1
let s:tree_sitter_available=0
if has('nvim-0.5.0')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    let s:tree_sitter_available=1
endif
let s:use_tree_sitter=and(s:use_tree_sitter, s:tree_sitter_available)

" ################ Fuzzy ################
let s:use_skim=0
let s:use_fzf=0
let s:use_telescope=0
let s:prefer_telescope=1
let s:prefer_skim=0
if and(s:prefer_telescope, has('nvim-0.5.0'))
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    let s:use_telescope=1
else
    if and(s:use_skim, executable('sk'))
        Plug 'lotabout/skim.vim'
        let s:use_skim=1
    elseif executable('fzf')
        Plug 'junegunn/fzf'
        let s:use_fzf=1
    endif
endif

" ################  DAP  ################
"if has('nvim-0.5.0')
"Plug 'mfussenegger/nvim-dap'
"
"endif

call plug#end()

" -------------------------------- LSP confing --------------------------------

if has('nvim-0.5.0')
call sign_define("LspDiagnosticsErrorSign", {"text" : "E", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "W", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "I", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})

lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
    local function buf_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_keymap('n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',               opts)
    buf_keymap('n', '<leader>a', '<Cmd>lua vim.lsp.buf.code_action()<CR>',                                opts)
    buf_keymap('n', '<leader>gD','<Cmd>lua vim.lsp.buf.declaration()<CR>',                                opts)
    buf_keymap('n', '<leader>gd','<Cmd>lua vim.lsp.buf.definition()<CR>',                                 opts)
    buf_keymap('n', 'K',         '<Cmd>lua vim.lsp.buf.hover()<CR>',                                      opts)
    buf_keymap('n', '<C-h>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>',                             opts)
    buf_keymap('i', '<C-h>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>',                             opts)
    buf_keymap('n', '<leader>gi','<cmd>lua vim.lsp.buf.implementation()<CR>',                             opts)
    buf_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
    buf_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
    buf_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                                     opts)
    buf_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>',                                 opts)
    buf_keymap('n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>',                            opts)
    buf_keymap('n', '[d',        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',                           opts)
    buf_keymap('n', ']d',        '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                           opts)
    buf_keymap('n', '<leader>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_keymap("n", "<leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_keymap("n", "<leader>=", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead  cterm=bold ctermbg=fg ctermfg=bg guibg=fg guifg=bg
        hi LspReferenceText  cterm=bold ctermbg=fg ctermfg=bg guibg=fg guifg=bg
        hi LspReferenceWrite cterm=bold ctermbg=fg ctermfg=bg guibg=fg guifg=bg
        augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end

    -- Replace default hooks
    vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
    vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
    vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
    vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
    vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
    vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
    vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
    vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = {
"rust_analyzer",
"clangd",
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
end

--[[
nvim_lsp.texlab.setup {
    name = 'texlab';
    on_attach = on_attach;
    settings = {
        latex = {
            build = {
                onSave = true;
            }
        }
    }
}
]]--
EOF
endif

set completeopt=menuone,preview,noinsert,noselect

" -------------------------------- Tree-Sitter --------------------------------

if s:use_tree_sitter
lua << EOF
    -- Indent
    require'nvim-treesitter.configs'.setup {
      indent = {
        enable = true
      }
    }

    -- Select
    require'nvim-treesitter.configs'.setup {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    }

    -- Highlight
    require'nvim-treesitter.configs'.setup {
      highlight = {
        enable = true,
        use_languagetree = true, -- Use this to enable language injection
      },
    }
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

set tabstop=4                 " Tab size
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
set updatetime=800

set hidden
set cmdheight=2

" Terminal mode settings
augroup TERM
    autocmd!
    function! TermEnter()
        if &buftype ==# 'terminal'
            startinsert
        endif
    endfunction

    autocmd TermOpen * setlocal nonumber
    autocmd TermOpen * setlocal nocursorline
    "autocmd TermOpen * startinsert
    "autocmd BufEnter * call TermEnter()
augroup end

" hightlight whitespaces

highlight! link ExtraWhitespace Error
match ExtraWhitespace /\s\+$/
augroup WHITESPACE
    autocmd!
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
    set grepprg=rg\ --vimgrep\ --ignore-case
endif

" FZF/Skim
if s:use_skim
    nnoremap <silent> <leader>b <cmd>Buffers<CR>
    nnoremap <silent> <leader>f <cmd>Files<CR>

    command! -bang -nargs=* Ag call fzf#vim#ag_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))
    command! -bang -nargs=* Rg call fzf#vim#rg_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))
elseif s:use_fzf
    nnoremap <silent> <leader>f <cmd>FZF<CR>
    command! FZFBuffers call fzf#run(fzf#wrap({'source': map(getbufinfo({'buflisted':1}), 'v:val.name'), 'sink': 'b'}))<CR>
    "nnoremap <silent> <leader>b <cmd>FZFBuffers<CR>
elseif s:use_telescope
    nnoremap <leader>faf <cmd>Telescope find_files<cr>
    nnoremap <leader>ff <cmd>Telescope git_files<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>ts <cmd>Telescope treesitter<cr>
    nnoremap <leader>ws <cmd>Telescope lsp_workspace_symbols<cr>
endif


" ---------------------------------- FOLDING ----------------------------------

set foldenable
set foldlevelstart=10
set foldnestmax=10
if s:use_tree_sitter
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
else
    set foldmethod=syntax
endif

" -------------------------------- SPELL CHECK --------------------------------

" highlight clear SpellBad
" highlight SpellBad cterm=underline
command! SpellCheckEng <cmd>setlocal spell spelllang=en
command! SpellCheckFra <cmd>setlocal spell spelllang=fr

" -------------------------------- FILE SEARCH --------------------------------

set path+=**
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
nnoremap <silent> <leader><leader> <cmd>call Cleanup()<cr>

" List buffers and prompt
nnoremap <leader>b :ls<cr>:b 

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
nnoremap <leader>s <cmd>%s/\<<C-r><C-w>\>//g<Left><Left>

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

function! Cleanup()
    pclose " Close preview window (lsp documentation etc)
    cclose " Close quickfix list (grep, lsp diagnostics)
    let @/ = "" " Erase current search
endfunction
