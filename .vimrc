" Brian Ustas's .vimrc
"
" ** Plugins **
"   - Pathogen (used to load below plugins): github.com/tpope/vim-pathogen
"   - Solarized: github.com/altercation/vim-colors-solarized
"   - Surround: github.com/tpope/vim-surround
"   - SuperTab: github.com/ervandew/supertab
"   - CommandT: github.com/wincent/Command-T
"
" If using MacVim:
" MacVim > Preferences > 'in the current window with a tab for each file'
" Add this to your .bashrc to open multiple files in tabs: alias mvim='mvim --remote-tab-silent'

"-- Pathogen
  try
    execute pathogen#infect()
  catch
    " Do nothing...
  endtry

  set nocompatible                " Don't start Vim in vi-compatibility mode
  set encoding=utf-8              " Set default encoding to UTF-8
"-- General
  if has('autocmd')
    filetype plugin indent on
  endif
  if has('syntax') && !exists('g:syntax_on')
    syntax enable
  endif

  set ffs=unix,dos,mac            " File Format (Relevant to line ending type)
  set mouse=a                     " Enable mouse support for all modes
  set backspace=indent,eol,start  " Make backspace work like most other apps
  set history=100                 " Keep 100 lines of command line history
  set showcmd                     " Display incomplete commands

  " Disable all error whistles
  set noerrorbells visualbell t_vb=
  if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
  endif

  set backupdir^=~/.vim/_backup//    " Where to put backup files
  set directory^=~/.vim/_temp//      " Where to put swap files

"-- UI
  set number                    " Line numbering
  set laststatus=2              " Always show a status line
  set statusline=%f\ %m\ %r     " file path, modified status, readonly status
  set statusline+=\ Line:%l/%L  " current line / all lines
  set statusline+=\ Buf:%n      " buffer number
  set background=dark

  if has('gui_running')
    set guifont=Menlo:h14,Consolas:h11
    set lines=35 columns=135    " Default window size
    set guioptions-=m           " Removes menubar
    set guioptions-=T           " Removes toolbar

    try
      colorscheme solarized
    catch
      colorscheme torte
    endtry
  else "running in the terminal...
    try
      let g:solarized_termtrans=1
      let g:solarized_termcolors=16
      colorscheme solarized
    catch
      colorscheme torte
    endtry
  endif

  " Visually define an 80 character limit
  if exists('+colorcolumn')
    set colorcolumn=80
    highlight ColorColumn ctermbg=Red guibg=#073642
  else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
  endif

"-- Search
  set nohlsearch      " Turn off highlight matching
  set incsearch       " Incremental searching
  set ignorecase      " Searches are case insensitive...
  set smartcase       " ...unless they contain at least one capital letter

"-- Whitespace
  set nowrap          " Don't wrap lines
  set expandtab       " Insert spaces instead of tabs when Tab is pressed
  set shiftwidth=2    " Sets the indentation width for < and >
  set tabstop=2       " Make 2 spaces behave like a tab
  set softtabstop=2

" -- Wild Mode (command line completion)
  set wildmenu
  set wildmode=list:longest,full
  " Disable output and VCS files
  set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
  " Disable archive files
  set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
  " Ignore bundler and SASS cache
  set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
  " Disable temp and backup files
  set wildignore+=*.swp,*~,._*

"-- Auto Commands
  if has('autocmd')
    "Wrap lines at 80 characters for all text files
    autocmd FileType text,markdown setlocal textwidth=80

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

    " Automatically resize splits when resizing window
    autocmd VimResized * wincmd =

    " Remove whitespace at the end of lines while maintaining cursor position
    fun! <SID>StripTrailingWhitespaces()
      let l = line('.')
      let c = col('.')
      %s/\s\+$//e
      call cursor(l, c)
    endfun
    autocmd FileType * autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

    " Treat all Markdown files the same
    au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown

    " Treat the following as Ruby files
    au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,config.ru,*.rake} set ft=ruby

    " Treat JSON files like JavaScript
    au BufNewFile,BufRead *.json set ft=javascript

    " Python PEP8 4 space indent
    au FileType python setlocal softtabstop=4 tabstop=4 shiftwidth=4
  endif
