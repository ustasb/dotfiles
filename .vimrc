" Brian Ustas's .vimrc
"
" Supports OS X and Linux (tested with Yosemite and Ubuntu 14.04).
"
""" Expected Installs
"
" - Git
" - Ruby and RSpec
" - GCC 4.8 Compiler
" - tmux (http://tmux.sourceforge.net)
" - ag (https://github.com/ggreer/the_silver_searcher)
" - ctags (http://ctags.sourceforge.net/)
" - Dash.app (http://kapeli.com/dash)
"
""" Plugins Requiring Additional Manual Installs
"
" - See suan/vim-instant-markdown
" - See 'Plugin Settings' for Syntastic (install JSHint)
"
""" Nice to Have
"
" - brew install rbenv-ctags (tags the Ruby standard library)

"=== Vundle
  filetype on   " Prevents Vim from having an issue with the next line if
  filetype off  " filetype is already off
  set nocompatible

  " Set the runtime path to include Vundle and initialize
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  Plugin 'gmarik/Vundle.vim'

  " Unite.vim
  Plugin 'Shougo/vimproc.vim'
  Plugin 'Shougo/unite.vim'
  Plugin 'Shougo/neomru.vim'
  Plugin 'h1mesuke/unite-outline'

  " Miscellaneous
  Plugin 'tpope/vim-commentary'
  Plugin 'scrooloose/nerdtree'
  Plugin 'scrooloose/syntastic'
  Plugin 'airblade/vim-gitgutter'
  Plugin 'tpope/vim-fugitive'
  Plugin 'jszakmeister/vim-togglecursor'
  Plugin 'Raimondi/delimitMate'
  Plugin 'justinmk/vim-sneak'

  " Requires a compile step
  Plugin 'Valloric/YouCompleteMe'

  " Requires ag (the silver searcher)
  Plugin 'rking/ag.vim'

  " tmux
  Plugin 'benmills/vimux'
  Plugin 'christoomey/vim-tmux-navigator'

  " Color scheme
  Plugin 'chriskempson/base16-vim'

  " Syntax
  Plugin 'othree/html5-syntax.vim'
  Plugin 'pangloss/vim-javascript'
  Plugin 'kchmck/vim-coffee-script'
  Plugin 'tikhomirov/vim-glsl'

  " Ruby
  Plugin 'vim-ruby/vim-ruby'
  Plugin 'thoughtbot/vim-rspec'

  " Vim Instant Markdown
  " Required on OS X: sudo chmod ugo-x /usr/libexec/path_helper
  Plugin 'suan/vim-instant-markdown'

  " Dash documentation (only works on OS X)
  Plugin 'rizzatti/dash.vim'

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
  set nofoldenable                " No text folding
  set shortmess=I                 " Don't show Vim's welcome message
  set shortmess+=a                " Make the save message shorter. Helps avoid the "Hit ENTER to continue" message

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
    set lines=35 columns=135         " Default window size
    set guioptions-=m                " Remove menubar
    set guioptions-=T                " Remove toolbar
    set guicursor+=a:blinkon0        " Disable cursor blinking
  endif

  " Visually define an 80 character limit
  set colorcolumn=80
  highlight ColorColumn ctermbg=234 guibg=#232323

"=== Search
  set nohlsearch      " Turn off highlight matching
  set incsearch       " Incremental searching
  set ignorecase      " Searches are case insensitive...
  set smartcase       " ...unless they contain at least one capital letter
  set nomagic         " Treat search characters literally

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

  " Use jk instead of <Esc> to enter Normal mode
  inoremap jk <Esc>
  inoremap kj <Esc>

  " Make shift-k do nothing
  nnoremap <S-k> <Nop>

  " Split navigation
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
  nnoremap <C-x> <C-w>x

  " Remap arrow keys to navigate buffers and tabs
  nnoremap <left> :bprev<CR>
  nnoremap <right> :bnext<CR>
  nnoremap <up> :tabnext<CR>
  nnoremap <down> :tabprev<CR>

  " Reselect visual block after indent/outdent
  vnoremap < <gv
  vnoremap > >gv

  " Background Vim with <Leader>z (bring back into foreground with `fg`)
  nnoremap <Leader>z <C-z>

  " cd into the directory containing the file in the buffer
  nnoremap <silent> <Leader>cd :lcd %:h<CR>

  " Swap two words
  nnoremap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

"=== Wild Mode (command-line completion)
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
  " 80 character line wrap for markdown and text files. Turn spell checking on
  au Filetype {text,markdown} setlocal textwidth=80 spell

"=== Misc
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Remove whitespace at the end of lines while maintaining cursor position
  function! <SID>StripTrailingWhitespaces()
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    call cursor(l, c)
  endfunction
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

  " Open a file in Google Chrome - OS X only
  function! OpenFileInChrome()
    exec 'silent !open -a "Google Chrome" "%"'
    redraw!
  endfunction
  command! Chrome call OpenFileInChrome()

  " Don't auto-comment the next line on Enter
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  " Create a tags file
  function! CreateCtagsFile()
    exec 'silent !ctags -R .'
    redraw!
  endfunction
  command! Ctags call CreateCtagsFile()

"=== Unite.vim

  call unite#filters#matcher_default#use(['matcher_fuzzy'])
  call unite#filters#sorter_default#use(['sorter_rank'])

  let g:unite_prompt = '❯ '
  let g:unite_winheight = 30
  let g:unite_data_directory='~/.vim/.cache/unite'
  let g:unite_enable_start_insert = 1  " Start in Insert mode
  let g:unite_enable_short_source_names = 1
  let g:unite_source_history_yank_enable = 1
  let g:unite_force_overwrite_statusline = 0  " Use Vim's default statusline
  let g:unite_source_file_mru_limit = 100
  let g:unite_source_file_mru_filename_format = ':~:.'  " Shorten MRU paths
  let g:unite_abbr_highlight = 'Normal'  " Needed by unite-outline

  " Try to keep in sync with Wildignore
  call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
    \ 'ignore_pattern', join([
    \ '\.git/',
    \ 'tmp/',
    \ 'node_modules/',
    \ 'vendor/',
    \ 'plugins/',
    \ 'bower_components/',
    \ '.sass-cache/',
    \ 'spec/cassettes/',
    \ ], '\|'))

  " No prefix for Unite
  nnoremap [unite] <Nop>
  " Search through all files recursively
  nnoremap <silent> <c-p> :<C-u>Unite -buffer-name=file_rec file_rec/async:!<CR>
  " MRU
  nnoremap <silent> <Leader>m :<C-u>Unite -buffer-name=mru file_mru<CR>
  " Open buffers
  nnoremap <silent> <Leader>b :<C-u>Unite -buffer-name=buffer buffer<CR>
  " File outline
  nnoremap <silent> <Leader>o :<C-u>Unite -buffer-name=outline outline<CR>
  " Notes
  nnoremap <silent> <Leader>n :<C-u>Unite -buffer-name=notes -path=/Users/ustasb/notes file_rec<CR>
  " Yank history
  nnoremap <silent> <Leader>y :<C-u>Unite -buffer-name=yanks history/yank<CR>
  " Vim commands
  nnoremap <silent> <Leader>c :<C-u>Unite -buffer-name=commands command<CR>
  " Vim mappings
  nnoremap <silent> <Leader>k :<C-u>Unite -buffer-name=mappings mapping<CR>

  if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
    let g:unite_source_grep_recursive_opt = ''
  endif
  " Grep - NOTE: Prefer Ag.vim right now
  " nnoremap <silent> <Leader>/ :<C-u>UniteWithCursorWord -buffer-name=search grep:.<CR>

  " Unite buffer settings
  autocmd FileType unite call s:unite_settings()
  function! s:unite_settings()
    " Exit with ESC
    nmap <buffer> <ESC> <Plug>(unite_exit)
    imap <buffer> <ESC> <Plug>(unite_exit)

    " qq to exit
    imap <buffer> qq <Plug>(unite_exit)

    " Navigate candidates with Ctrl j and k
    imap <buffer> <C-j> <Plug>(unite_select_next_line)
    imap <buffer> <C-k> <Plug>(unite_select_previous_line)

    " Ctrl-r to refresh the buffer
    nmap <buffer> <C-r> <Plug>(unite_redraw)
    imap <buffer> <C-r> <Plug>(unite_redraw)
  endfunction

"=== Plugin Settings
  " Base16 color schemes
  if has('gui_running')
    set guifont=Source\ Code\ Pro:h13  " github.com/adobe/source-code-pro/downloads
    set background=light
    silent! colorscheme base16-google
  else
    set background=dark
    silent! colorscheme base16-tomorrow
  endif

  " Andy Wokula's HTML Indent
  let g:html_indent_inctags = 'html,body,head,tbody'
  let g:html_indent_script1 = 'inc'
  let g:html_indent_style1 = 'inc'

  " Syntastic -- enable C++11 support
  let g:syntastic_cpp_checkers = ['gcc']
  let g:syntastic_cpp_compiler = 'g++-4.8'
  let g:syntastic_cpp_compiler_options = '-std=c++11'
  " For JavaScript linting, install JSHint: `npm install -g jshint`

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

  " NERD Tree
  map <C-n> :NERDTreeToggle<CR>
  let NERDTreeIgnore=['\.o$']
  nmap <Leader>f :NERDTreeFind<CR>
  let NERDTreeShowHidden=1
  let NERDTreeShowBookmarks=1

  " GitGutter
  let g:gitgutter_realtime = 0  " Only run on read and write
  let g:gitgutter_eager = 0     " ^^

  " Dash
  nmap <Leader>d :Dash<CR>

  " Vim Toggle Cursor
  let g:togglecursor_default = 'block'
  let g:togglecursor_insert = 'line'
  let g:togglecursor_leave = 'line'

  " Sneak.vim
  let g:sneak#streak = 1  " Behave like EasyMotion
