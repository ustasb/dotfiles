" Brian Ustas's .vimrc

"=== Vundle
  filetype on   " Prevents Vim from having an issue with the next line if
  filetype off  " filetype is already off.
  set nocompatible

  " Set the runtime path to include Vundle and initialize
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()

  Plugin 'gmarik/Vundle.vim'

  Plugin 'kien/ctrlp.vim'
  Plugin 'scrooloose/nerdtree'
  Plugin 'scrooloose/nerdcommenter'
  Plugin 'ervandew/supertab'
  Plugin 'scrooloose/syntastic'
  Plugin 'airblade/vim-gitgutter'

  " brew install ctags
  Plugin 'majutsushi/tagbar'

  Plugin 'tikhomirov/vim-glsl'

  " brew install the_silver_searcher
  Plugin 'rking/ag.vim'

  Plugin 'benmills/vimux'
  Plugin 'christoomey/vim-tmux-navigator'

  Plugin 'chriskempson/base16-vim'

  Plugin 'othree/html5-syntax.vim'
  Plugin 'mattn/emmet-vim'
  Plugin 'pangloss/vim-javascript'
  Plugin 'kchmck/vim-coffee-script'

  Plugin 'vim-ruby/vim-ruby'
  Plugin 'thoughtbot/vim-rspec'

  " Vim Notes plugin
  Plugin 'xolox/vim-misc'
  Plugin 'xolox/vim-notes'

  " vim-markdown
  Plugin 'godlygeek/tabular'
  Plugin 'plasticboy/vim-markdown'

  " Vim Instant Markdown
  " Required: sudo chmod ugo-x /usr/libexec/path_helper
  Plugin 'suan/vim-instant-markdown'

  call vundle#end()
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

  " Redraw the Vim view
  nnoremap <Leader>l :redraw!<CR>

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
  " Tomorrow-Night
  set background=dark
  silent! colorscheme base16-tomorrow

  " Andy Wokula's HTML Indent
  let g:html_indent_inctags = 'html,body,head,tbody'
  let g:html_indent_script1 = 'inc'
  let g:html_indent_style1 = 'inc'

  " Syntastic -- enable C++11 support
  "let g:syntastic_check_on_open=1
  let g:syntastic_cpp_checkers = ['gcc']
  let g:syntastic_cpp_compiler = 'g++-4.8'
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
  " REPL commands
  nnoremap <Leader>rr :call VimuxRunCommand('clear; ruby ' . expand('%:p'))<CR>
  nnoremap <Leader>rc :call VimuxRunCommand('clear; g++ -o /tmp/a.out ' . expand('%:p') . '; /tmp/a.out')<CR>

  " NERDTree
  map <C-n> :NERDTreeToggle<CR>
  nmap <Leader>n :NERDTreeFind<CR>
  let NERDTreeIgnore=['\.o$']

  " GitGutter
  let g:gitgutter_realtime = 0  " Only run on read and write
  let g:gitgutter_eager = 0     " ^^

  " Tagbar
  nmap <C-t> :Tagbar<CR>

  " Vim Notes
  let g:notes_directories = ['~/Google Drive/documents/notes/notes']
  let g:notes_suffix = '.md'
  let g:notes_smart_quotes = 0
  let g:notes_tab_indents = 0
  let g:notes_alt_indents = 0

  " Vim Markdown
  let g:vim_markdown_folding_disabled=1
  let g:vim_markdown_no_default_key_mappings=1

  " Vim Instant Markdown
  let g:instant_markdown_slow = 1
