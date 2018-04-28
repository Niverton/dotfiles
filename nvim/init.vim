scriptencoding=utf-8
" ------------------------------- PLUGIN SECTION ------------------------------
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

  call plug#begin('~/.local/share/nvim/plugged')

  " Gruvbox
  Plug 'morhetz/gruvbox'
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_contrast_light='hard'
    let g:gruvbox_inverse='1'
    let g:gruvbox_italic='1'

  " Session manager
  Plug 'tpope/vim-obsession'

  "Auto close tags
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-ragtag'
  Plug 'tpope/vim-surround'

  "Comment
  Plug 'tpope/vim-commentary'

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
  let g:ale_echo_msg_format = '%severity% [%linter%]% code%: %s'
  let g:ale_linters = {
  \     'cpp':  ['clang',
  \             'clangtidy',
  \             'cppcheck',
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
  let g:ale_cpp_clangtidy_checks = [
  \     '*',
  \     '-android*',
  \     '-google*',
  \     '-fuchsia*',
  \     '-llvm-header-guard',
  \     '-cppcoreguidelines-pro-type-union-access',
  \     '-cppcoreguidelines-pro-bounds-array-to-pointer-decay',
  \     '-hicpp-no-array-decay'
  \]
  let g:ale_cpp_cppcheck_options = '--enable=warning,performance,information,style'

  "let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_insert_leave = 1
      "Remaps
  nmap <silent> <leader>k <Plug>(ale_previous_wrap)
  nmap <silent> <leader>j <Plug>(ale_next_wrap)

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

  " Git
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'

  " LightLine
  Plug 'itchyny/lightline.vim'
  Plug 'hanschen/lightline-gruvbox.vim'
  let g:lightline = {
        \ 'colorscheme': 'gruvbox',
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

  " GLSL
  Plug 'tikhomirov/vim-glsl'

  " Latex
  "Plug 'vim-latex/vim-latex'
  

  " Snippets
  Plug 'SirVer/ultisnips'
  let g:UltiSnipsEditSplit="context"
  "Plug 'honza/vim-snippets'
  Plug 'niverton/niv-snippets'

  call plug#end()

" -------------------------------- COLORSCHEME --------------------------------

  "Set the background according to time of day
  "let time = str2nr(system("date +%-H"))
  "if time >= 18 || time < 8
  "  set background=dark
  "else
  "  set background=light
  "endif
  "unlet time
  "
  set background=dark

  " Enable true color support
  set termguicolors
  colorscheme gruvbox

" ---------------------------------- SETTINGS ---------------------------------

  " Unmap space for use as leader
  nnoremap <Space> <nop>
  let g:mapleader="\<Space>"
  "set tabstop=8           " Tab size
  set shiftwidth=2        " Indent size
  "set softtabstop=8       " see help
  set expandtab           " Use spaces instead of tabs
  "set number             " Display line numbers
  set textwidth=72        " Line wrap at 72 chars
  set cursorline          " highlight cursor line
  set mouse=a
  filetype indent on
  set lazyredraw          " Redraw screen only when needed
  set noshowmode
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
  "nnoremap <space> za


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

  "let g:netrw_banner=0        " disable banner
  let g:netrw_browse_split=0  " open in current window
  let g:netrw_altv=1          " open splits to the right
  let g:netrw_liststyle=3     " tree view

" ----------------------------------- REMAPS ----------------------------------

    " Remove trailing whitespaces
    " (http://vim.wikia.com/wiki/Remove_unwanted_spaces)
  command! Trim :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
      "Insert new line
  nmap <leader>O O<Esc>j
  nmap <leader>o o<Esc>k
  

  nnoremap j gj
  nnoremap k gk
    " Make
  nnoremap <leader>m :make<CR>

    "List buffers and prompt
  nnoremap <leader>b :ls<CR>:buffer 
    "List tabs and switch
  nnoremap <leader>v :tabs<CR>:tabnext 

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
  "nnoremap <A-h> <C-w>h
  "nnoremap <A-j> <C-w>j
  "nnoremap <A-k> <C-w>k
  "nnoremap <A-l> <C-w>l
      " Stop using arrow keys
  nnoremap <Left>  <C-w>h
  nnoremap <Down>  <C-w>j
  nnoremap <Up>    <C-w>k
  nnoremap <Right> <C-w>l
  "inoremap <Left>  <nop>
  "inoremap <Down>  <nop>
  "inoremap <Up>    <nop>
  "inoremap <Right> <nop>

      " Replace all occurences of word under cursor
  nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
      " Navigate buffers quickly
  nnoremap <C-q> :bnext<CR>
  nnoremap <C-s> :bprevious<CR>

      " Move line
      " Up
  nnoremap <A-k> "mddk"mP
      " Down
  nnoremap <A-j> "mdd"mp

" ------------------------------ CUSTOM FUNCTIONS -----------------------------

  nnoremap <leader>h :call SwitchHeaderToSource()<CR>
  function! SwitchHeaderToSource()
      if expand('%:e') == 'h' || expand('%:e') == 'hpp'
          if filereadable(expand('%:r').'.cpp')
              execute ':find '.expand('%:r').'.cpp'
          elseif filereadable(expand('%:r').'.cc')
              execute ':find '.expand('%:r').'.cc'
          elseif filereadable(expand('%:r').'.c')
              execute ':find '.expand('%:r').'.c'
          else
              echo "Source file doesn't exist"
          endif
      elseif expand('%:e') == 'c' || expand('%:e') == 'cpp' || expand('%:e') == 'cc'
          if filereadable(expand('%:r').'.hpp')
              execute ':find '.expand('%:r').'.hpp'
          elseif filereadable(expand('%:r').'.h')
              execute ':find '.expand('%:r').'.h'
          else
              echo "Source file doesn't exist"
          endif


      endif
  endfunction


  " Lightline
  function! LightlineFilename()
    let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
    let modified = &modified ? '+' : ''
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
