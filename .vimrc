" Brian Ustas's .vimrc

"=== Vundle
  filetype on   " Prevents Vim from having an issue with the next line if
  filetype off  " filetype is already off.
  set nocompatible

  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
  Bundle 'gmarik/vundle'

  Bundle 'kien/ctrlp.vim'
  Bundle 'scrooloose/nerdtree'
  Bundle 'scrooloose/nerdcommenter'
  Bundle 'ervandew/supertab'
  Bundle 'scrooloose/syntastic'

  " brew install the_silver_searcher
  Bundle 'rking/ag.vim'

  Bundle 'benmills/vimux'
  Bundle 'christoomey/vim-tmux-navigator'

  Bundle 'nanotech/jellybeans.vim'

  Bundle 'othree/html5-syntax.vim'
  Bundle 'pangloss/vim-javascript'
  Bundle 'kchmck/vim-coffee-script'

  Bundle 'vim-ruby/vim-ruby'
  Bundle 'thoughtbot/vim-rspec'

  filetype plugin indent on

"=== Basic
  syntax enable
  set encoding=utf-8              " Set default encoding to UTF-8
  set ffs=unix,dos,mac            " File Format (relevant to line ending type)
  set mouse=a                     " Enable mouse support for all modes
  set backspace=indent,eol,start  " Make backspace work like most other apps
  set history=100                 " Keep 100 lines of command-line history
  set showcmd                     " Display incomplete commands
  set title                       " Change the title of the terminal/tab with the file name
  set hidden                      " Allow unsaved background buffers
  set ttimeoutlen=100             " Prevent Shift-O delay in terminal
  set scrolloff=3                 " Keep 3 lines above/below cursor when scrolling up/down beyond viewport boundaries
  set clipboard=unnamed           " Merge Vim and OS clipboard
  set tags=./tags;/               " Set the tag file search order: current directory then root (used by Ctags)
  set complete=.,w,b,u,i          " Keyword completion (don't search the tag file)
  set formatoptions-=cro          " Don't auto-comment the next line
  set shortmess=I                 " Don't show Vim's welcome message

  " Open new split panes to the bottom and right
  set splitbelow
  set splitright

  " Disable all error whistles
  set noerrorbells visualbell t_vb=

  " Backups
  set backup
  set backupdir=/var/tmp//,/tmp//,.
  set noswapfile

  " Resize splits when Vim is resized
  au VimResized * wincmd =

"=== UI
  " Status Line
  set laststatus=2              " Always show a status line
  set statusline=%f\ %m\ %r     " file path, modified status, read-only status
  set statusline+=\ Line:%l/%L  " current line / all lines
  set statusline+=\ Buf:%n      " buffer number

  " GUI
  if has('gui_running')
    set guifont=Source\ Code\ Pro\ Light:h13  " github.com/adobe/source-code-pro/downloads
    set lines=35 columns=135         " Default window size
    set guioptions-=m                " Remove menubar
    set guioptions-=T                " Remove toolbar
  endif

  " Visually define an 80 character limit
  set colorcolumn=80
  highlight ColorColumn ctermbg=234 guibg=#232323

"=== Search
  set nohlsearch      " Turn off highlight matching
  set incsearch       " Incremental searching
  set ignorecase      " Searches are case insensitive...
  set smartcase       " ...unless they contain at least one capital letter

"=== Whitespace
  set autoindent      " Turn on autoindenting
  set nowrap          " Don't wrap lines
  set expandtab       " Insert spaces instead of tabs when <Tab> is pressed
  set shiftwidth=2    " Set the indentation width for < and >
  set tabstop=2       " Make 2 spaces behave like a tab
  set softtabstop=2

"=== Key Mappings
  " Change the leader key from \ to ,
  let mapleader=','

  " Enter Ex mode with :
  map ; :

  " Use jk instead of <Esc> to enter Normal mode
  inoremap jk <Esc>

  " Make shift-k do nothing
  nnoremap <S-k> <Nop>

  " Split navigation
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
  nnoremap <C-x> <C-w>x

  " Reselect visual block after indent/outdent
  vnoremap < <gv
  vnoremap > >gv

  " Background Vim with <Leader>z (bring back into foreground with `fg`)
  nnoremap <Leader>z <C-z>

  " cd into the directory containing the file in the buffer
  nnoremap <silent> <Leader>cd :lcd %:h<CR>

  " Swap two words
  nnoremap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

"=== Wild Mode (command-line completion, also used by CtrlP to ignore files)
  set wildmenu
  set wildmode=list:longest,full
  set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
  " Ignore archive files
  set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
  " Ignore Bundler and SASS cache
  set wildignore+=*/vendor/gems/*,*/vendor/bundle/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
  " Ignore node.js modules
  set wildignore+=*/node_modules/*
  " Ignore temp and backup files
  set wildignore+=*.swp,*~,._*

"=== Files
  " Markdown files
  au BufNewFile,BufRead *.{md,markdown,mdown,mkd,mkdn} set filetype=markdown
  " Ruby files
  au BufNewFile,BufRead {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,config.ru,*.rake} set filetype=ruby
  " Treat JSON files as JavaScript
  au BufNewFile,BufRead *.json set filetype=javascript
  " Treat Handlebars files as HTML
  au BufNewFile,BufRead *{.handlebars,hbs} set filetype=html.js
  " Treat LESS files as CSS
  au BufNewFile,BufRead *.less set filetype=css
  " Python PEP8 4 space indent
  au FileType python setlocal softtabstop=4 tabstop=4 shiftwidth=4

"=== Misc
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Remove whitespace at the end of lines while maintaining cursor position
  fun! <SID>StripTrailingWhitespaces()
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    call cursor(l, c)
  endfun
  au FileType * au BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

  " Rename the current file (credit: Gary Bernhardt)
  function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
      exec ':saveas ' . new_name
      exec ':silent !rm ' . old_name
      redraw!
    endif
  endfunction
  map <Leader>rn :call RenameFile()<cr>

"=== Plugin Settings
  " Jellybeans
  set background=dark
  set t_Co=256
  silent! colorscheme jellybeans

  " Andy Wokula's HTML Indent
  let g:html_indent_inctags = 'html,body,head,tbody'
  let g:html_indent_script1 = 'inc'
  let g:html_indent_style1 = 'inc'

  " Syntastic -- enable C++11 support
  "let g:syntastic_check_on_open=1
  let g:syntastic_cpp_checkers = ['gcc']
  let g:syntastic_cpp_compiler = 'g++-4.9'
  let g:syntastic_cpp_compiler_options = '-std=c++11'

  " CtrlP
  nnoremap <C-g> :CtrlPBuffer<CR>
  let g:ctrlp_working_path_mode = 0  " Use Vim's current working directory as the search root
  if executable('ag')
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
  endif

  " vim-javascript
  let g:javascript_ignore_javaScriptdoc = 1

  " vim-coffee-script
  hi link coffeeSpaceError NONE  " Don't highlight trailing whitespace

  " RSpec.vim
  nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
  nnoremap <Leader>s :call RunNearestSpec()<CR>

  " Vimux
  let g:rspec_command = 'call VimuxRunCommand("bundle exec rspec {spec}")'
  nnoremap <Leader>rb :call VimuxRunCommand('clear; ruby ' . expand('%:p'))<CR>

  " NERDTree
  map <C-n> :NERDTreeToggle<CR>
