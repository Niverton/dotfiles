scriptencoding=utf-8
" ------------------------------- PLUGIN SECTION ------------------------------ 
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

  call plug#begin('~/.local/share/nvim/plugged')

  " Oceanic-next Theme
  "Plug 'mhartington/oceanic-next'

  " Minimalist
  "Plug 'dikiaap/minimalist'

  " Gruvbox
  Plug 'morhetz/gruvbox'
    let g:gruvbox_contrast_dark='hard'
    let g:gruvbox_contrast_light='medium'
    let g:gruvbox_inverse='1'
    let g:gruvbox_italic='1'

  " Session manager
  Plug 'tpope/vim-obsession'

  "Auto close tags
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-ragtag'

  "Comment
  Plug 'tpope/vim-commentary'

  "Auto close pairs
  Plug 'jiangmiao/auto-pairs'

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

  "
  Plug 'plasticboy/vim-markdown'

  " Asynchronous Lint Engine
  Plug 'w0rp/ale'
  "Config
  let g:ale_linters = {
  \     'cpp':  ['clang',
  \             'clangtidy',
  \             'clang-format'],
  \     'c':    ['clang',
  \             'clangtidy',
  \             'clang-format'],
  \}
  let g:ale_fixers = {
  \     'cpp':  ['clangtidy',
  \             'clang-format'],
  \     'c':    ['clangtidy',
  \             'clang-format'],
  \}
  let g:ale_c_build_dir_names = ['build', 'bin', 'debug', 'release']

  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_insert_leave = 0
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
     "Use echo bar for documentation
  Plug 'Shougo/echodoc.vim'

  "Plug 'roxma/nvim-completion-manager'
  "Plug 'roxma/ncm-clang'

  " LSP
  "Plug 'autozimu/LanguageClient-neovim', {
  "    \ 'branch': 'next',
  "    \ 'do': 'bash install.sh',
  "    \ }
  "let g:LanguageClient_autoStart = 1
  "let g:LanguageClient_serverCommands = {
  "    \ 'cpp': ['clangd',],
  "    \ }

  " GDScript syntax
  Plug 'a-watson/vim-gdscript'

  " Git
  Plug 'tpope/vim-fugitive'

  " Beautify separators
  Plug 'guywald1/vim-prismo'
  let g:prismo_dash='—'

  Plug 'vim-airline/vim-airline'
  let g:airline_powerline_fonts = 1
  "let g:airline_extensions = ['whitespace']             "Extensions whitelist
  let g:airline_highlighting_cache = 1                  "Enable cache
  let g:airline#extensions#ale#enabled = 1              "ALE

  let g:ale_echo_msg_format = '%severity% [%linter%]% code%: %s'

  " Clang Format
  Plug 'rhysd/vim-clang-format'
  " Look for style file
  let g:clang_format#detect_style_file = 1
  " Default style
  let g:clang_format#code_style = 'llvm'
  let g:clang_format#style_options = {
      \ 'AlwaysBreakTemplateDeclarations' : 'true',
      \ 'Standard' : 'C++11',
      \}
  " Auto enable
  "autocmd FileType c,cpp,objc ClangFormatAutoEnable
  " Leader + f
  autocmd FileType c,cpp,objc nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>
  autocmd FileType c,cpp,objc vnoremap <buffer><Leader>f :ClangFormat<CR>

  "GLSL
  Plug 'tikhomirov/vim-glsl'

  call plug#end()

" -------------------------------- COLORSCHEME --------------------------------

  " Enable true color support
  set termguicolors
  let s:cs='gruvbox'
  set background=dark
  " Set colorscheme from var
  execute 'colorscheme ' . s:cs
  let g:airline_theme=s:cs
  let g:airline_powerline_fonts = 1
  "let g:airline#extensions#tabline#enabled = 1

" ---------------------------------- SETTINGS ---------------------------------

  let g:mapleader=','
  set tabstop=8           " Tab size
  set shiftwidth=2        " Indent size
  set softtabstop=8       " see help
  set expandtab           " Use spaces instead of tabs
  "set number             " Display line numbers
  set textwidth=72        " Line wrap at 72 chars
  set cursorline          " highlight cursor line
  set mouse=a
  filetype indent on
  set lazyredraw          "Redraw screen only when needed
  set showmatch
  set autoread

" ----------------------------------- SEARCH ----------------------------------

  set ignorecase
  set smartcase
  set incsearch           "Search when typing
  set hlsearch

" ---------------------------------- FOLDING ----------------------------------

  set foldenable
  set foldlevelstart=10
  set foldnestmax=10
  set foldmethod=indent
  "Toggle fold
  nnoremap <space> za


" -------------------------------- SPELL CHECK --------------------------------

  highlight clear SpellBad
  highlight SpellBad cterm=underline
  command! SpellCheckEng :setlocal spell spelllang=en
  command! SpellCheckFra :setlocal spell spelllang=fr

" ----------------------------- FUZZY FILE SEARCH -----------------------------

  set path+=**
  set wildmenu
  set wildignorecase
  " ignore these files when completing names and in Ex
  set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam
  " set of file name suffixes that will be given a lower priority when
  " it comes to matching wildcards
  set suffixes+=.old

" -------------------------------- NETRW CONFIG -------------------------------

  let g:netrw_banner=0        " disable banner
  let g:netrw_browse_split=0  " open in current window
  let g:netrw_altv=1          " open splits to the right
  let g:netrw_liststyle=3     " tree view

" ----------------------------------- REMAPS ----------------------------------

    " Remove trailing whitespaces
    " (http://vim.wikia.com/wiki/Remove_unwanted_spaces)
  nnoremap <leader>t :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
      "Insert new line
  nmap OO O<Esc>j
  nmap oo o<Esc>k

  nnoremap j gj
  nnoremap k gk

      " ctags -R .
  "nnoremap <leader>m !ctags -R .<CR>
  command! Ctags :silent !ctags -R .
  command! Cpptags :silent !ctags -R . --c++-kinds=+p --fields=+iaS --extras=+q
      " Re-execute previous command prepending bang (!)
  nnoremap <leader>! :<Up><Home>!<CR>
      " Save file as root
          " Write buffer to tee standard input, dump the output and save it to
          " file.
  cnoremap w!! w !sudo tee % > /dev/null %
      " Nohl && close preview window
  nnoremap <leader><leader> :nohl<CR>:pc<CR>
      " Nonumber
  let g:numberstatus=0
  nnoremap <silent> <leader>n :if (numberstatus%2 == 0) \| set number \| else \| set nonumber \| endif \| let numberstatus=numberstatus+1<cr>
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

      " Move line
  nnoremap <A-Up> "mddk"mP
  nnoremap <A-Down> "mdd"mp

" ------------------------------ CUSTOM FUNCTIONS -----------------------------

  nnoremap <leader>o :call SwitchHeaderToSource()<CR>
  function! SwitchHeaderToSource()
      if expand('%:e') == 'h' || expand('%:e') == 'hpp'
          if filereadable(expand('%:r').'.cpp')
              execute ':edit '.expand('%:r').'.cpp'
          elseif filereadable(expand('%:r').'.cc')
              execute ':edit '.expand('%:r').'.cc'
          elseif filereadable(expand('%:r').'.c')
              execute ':edit '.expand('%:r').'.c'
          else
              echo "Source file doesn't exist"
          endif
      elseif expand('%:e') == 'c' || expand('%:e') == 'cpp' || expand('%:e') == 'cc'
          if filereadable(expand('%:r').'.hpp')
              execute ':edit '.expand('%:r').'.hpp'
          elseif filereadable(expand('%:r').'.h')
              execute ':edit '.expand('%:r').'.h'
          else
              echo "Source file doesn't exist"
          endif


      endif
  endfunction
