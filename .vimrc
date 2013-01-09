" Brian Ustas's .vimrc

"-- Pathogen
  try
    runtime bundle/pathogen/autoload/pathogen.vim
    execute pathogen#infect()
  catch
    " Do nothing...
  endtry

"-- General
  if has('autocmd')
    filetype plugin indent on
  endif
  if has('syntax') && !exists('g:syntax_on')
    syntax enable
  endif

  set nocompatible                " Don't start Vim in vi-compatibility mode
  set encoding=utf-8              " Set default encoding to UTF-8
  set ffs=unix,dos,mac            " File Format (Relevant to line ending type)
  set mouse=a                     " Enable mouse support for all modes
  set backspace=indent,eol,start  " Make backspace work like most other apps
  set history=100                 " Keep 100 lines of command line history
  set showcmd                     " Display incomplete commands
  set title                       " Change the title of the terminal/tab with the file name
  set hidden                      " Allow unsaved background buffers and remember marks/undo for them
  set pastetoggle=<F2>            " When toggled, Vim's autoindent won't interfere with pasting content normally

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

  try
    colorscheme ir_black
  catch
    colorscheme torte
  endtry

  if has('gui_running')
    set guifont=Menlo:h14,Consolas:h11
    set lines=35 columns=135    " Default window size
    set guioptions-=m           " Removes menubar
    set guioptions-=T           " Removes toolbar
  endif

  " Visually define an 80 character limit
  if exists('+colorcolumn')
    set colorcolumn=80
    highlight ColorColumn ctermbg=Black guibg=#202020
  endif

"-- Search
  set nohlsearch      " Turn off highlight matching
  set incsearch       " Incremental searching
  set ignorecase      " Searches are case insensitive...
  set smartcase       " ...unless they contain at least one capital letter

"-- Whitespace
  set autoindent      " Turn on autoindenting
  set nowrap          " Don't wrap lines
  set expandtab       " Insert spaces instead of tabs when Tab is pressed
  set shiftwidth=2    " Sets the indentation width for < and >
  set tabstop=2       " Make 2 spaces behave like a tab
  set softtabstop=2

"-- Key Mappings
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l

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
