" ------------------------------- PLUGIN SECTION ------------------------------
call plug#begin('~/.local/share/nvim/plugged')

" Oceanic-next Theme
" Plug 'mhartington/oceanic-next'

" Session manager
Plug 'tpope/vim-obsession'

" Python modules manager
Plug 'roxma/python-support.nvim'
let g:python_support_python2_require = 0

" for python completions
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'jedi')
" language specific completions on markdown file
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'mistune')

" utils, optional
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'psutil')
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'setproctitle')

" Vim Airline
Plug 'vim-airline/vim-airline'

let g:airline_theme='minimalist'
let g:airline#extensions#tabline#enabled=1

" Minimalist
Plug 'dikiaap/minimalist'

Plug 'plasticboy/vim-markdown'

" Asynchronous Lint Engine
Plug 'w0rp/ale'
"Config
let g:ale_linters = {
      \   'cpp': ['gcc'],
\}
let g:ale_cpp_clang_config='-std=c++1z -Wall -I. -I../include -I./include'
" let g:ale_cpp_gcc_config='-std=c++1z -Wall -I. -I../include -I./include'
    "Remaps
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"Deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang'
    "Complete from included files
Plug 'Shougo/neoinclude.vim'

" Autoclose parenthesis etc.
Plug 'Raimondi/delimitMate'

" GDScript syntax
Plug 'a-watson/vim-gdscript'

Plug 'kovetskiy/sxhkd-vim'

" Git
Plug 'tpope/vim-fugitive'

" Beautify separators
Plug 'guywald1/vim-prismo'
let g:prismo_dash='—'
nnoremap <leader>pr :Prismo<CR>

call plug#end()

" -------------------------------- COLORSCHEME --------------------------------

colorscheme minimalist

" ---------------------------------- SETTINGS ---------------------------------

let mapleader=','
set nofoldenable        " Disable folding
set tabstop=2           " Tab size
set shiftwidth=2        " Indent size
set softtabstop=-1      " see help
set expandtab           " Use spaces instead of tabs
set number              " Display line numbers
set cursorline          " highlight cursor line
set mouse=a
set ignorecase
set smartcase

" -------------------------------- SPELL CHECK --------------------------------
  highlight clear SpellBad
  highlight SpellBad cterm=underline
  command! SpellCheckEng :setlocal spell spelllang=en
  command! SpellCheckFra :setlocal spell spelllang=fr

" ----------------------------- FUZZY FILE SEARCH -----------------------------
  set path+=**
  set wildmenu
  set wildignorecase

" -------------------------------- NETRW CONFIG -------------------------------
  let g:netrw_banner=0        " disable banner
  let g:netrw_browse_split=0  " open in current window
  let g:netrw_altv=1          " open splits to the right
  let g:netrw_liststyle=3     " tree view

" ----------------------------------- REMAPS ----------------------------------
    " Remove trailing whitespaces
    " (http://vim.wikia.com/wiki/Remove_unwanted_spaces)
nnoremap <leader>t :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
    " ctags -R .
nnoremap <leader>m !ctags -R .<CR>
    " Re-execute previous command prepending bang (!)
nnoremap <leader>! :<Up><Home>!<CR>
    " Save file as root
        " Write buffer to tee standard input, dump the output and save it to
        " file.
cmap w!! w !sudo tee % > /dev/null %
    " Nohl
nnoremap <leader><leader> :nohl<CR>
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
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
    " Replace all occurences of word under cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
    " Navigate buffers quickly
nnoremap <C-q> :bnext<CR>
nnoremap <C-s> :bprevious<CR>

" ------------------------------ CUSTOM FUNCTIONS -----------------------------
nnoremap <leader>o :call SwitchHeaderToSource()<CR>
function! SwitchHeaderToSource()
    if expand('%:e') == 'h' || expand('%:e') == 'hpp'
        if filereadable(expand('%:r').'.cpp')
            execute ':edit '.expand('%:r').'.cpp'
        elseif filereadable(expand('%:r').'.c')
            execute ':edit '.expand('%:r').'.c'
        else
            echo "Source file doesn't exist"
        endif
    elseif expand('%:e') == 'c' || expand('%:e') == 'cpp'
        if filereadable(expand('%:r').'.hpp')
            execute ':edit '.expand('%:r').'.hpp'
        elseif filereadable(expand('%:r').'.h')
            execute ':edit '.expand('%:r').'.h'
        else
            echo "Source file doesn't exist"
        endif


    endif
endfunction
