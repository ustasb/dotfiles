" Brian Ustas's .vimrc
"
" Supports OS X and Linux (tested with Sierra and Ubuntu 14.04).
" For MacVim + Zsh, see: https://github.com/b4winckler/macvim/wiki/Troubleshooting#for-zsh-users
"
""" Expected Installs
"
" - Git
" - Ruby and RSpec
" - tmux (http://tmux.sourceforge.net)
" - ag (https://github.com/ggreer/the_silver_searcher)
" - ctags (http://ctags.sourceforge.net/)
" - fzf (https://github.com/junegunn/fzf)
" - pandoc (https://pandoc.org)

"=== Vim-Plug
  call plug#begin('~/.vim/plugged')
    " Miscellaneous
    Plug 'tpope/vim-commentary', { 'on': 'Commentary' }
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'Raimondi/delimitMate'
    Plug 'szw/vim-maximizer', { 'on': 'MaximizerToggle' }
    Plug 'ajh17/VimCompletesMe'
    Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
    Plug 'ustasb/scratch.vim'
    Plug 'justinmk/vim-sneak'

    " Git
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'

    " Markdown
    Plug 'tpope/vim-markdown', { 'for': 'markdown' } " Vim uses this syntax file by default. I always want the latest.
    Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown' }
    Plug 'ustasb/vim-markdown-preview', { 'for': 'markdown' }
    Plug 'vim-voom/VOoM', { 'for': 'markdown' }

    " GPG
    Plug 'jamessan/vim-gnupg'

    " Requires ag (The Silver Searcher)
    " Don't use vim-plug's lazy loading here! :Ack on text below the cursor
    " won't work the first time.
    Plug 'mileszs/ack.vim'

    " Super fast file fuzzy-finding.
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

    " tmux
    Plug 'benmills/vimux'
    Plug 'christoomey/vim-tmux-navigator'

    " Color schemes
    Plug 'chriskempson/base16-vim'
    Plug 'reedes/vim-colors-pencil'

    " Syntax
    Plug 'othree/html5-syntax.vim', { 'for': 'html' }
    Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
    Plug 'mxw/vim-jsx', { 'for': 'javascript' }
    Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

    " Ruby
    Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
    Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }
  call plug#end()

"=== Basic
  filetype plugin indent on
  syntax enable

  set encoding=utf-8              " Set default encoding to UTF-8.
  set spelllang=en_us             " US English spelling
  set spellfile=$USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/vim/vim-spell-en.utf-8.add " Custom spellfile
  set ffs=unix,dos,mac            " File Format (relevant to line ending type)
  set mouse=a                     " Enable mouse support for all modes.
  set backspace=indent,eol,start  " Make backspace work like most other apps.
  set history=100                 " Keep 100 lines of command-line history.
  set undolevels=100              " Keep 100 lines of undo history.
  set showcmd                     " Display incomplete commands.
  set title                       " Change the title of the terminal/tab with the file name.
  set hidden                      " Allow unsaved background buffers.
  set ttimeoutlen=100             " Prevent Shift-O delay in terminal.
  set scrolloff=3                 " Keep 3 lines above/below cursor when scrolling up/down beyond viewport boundaries.
  set clipboard=unnamed           " Merge Vim and OS clipboard.
  set tags=./tags;/               " Set the tag file search order: current directory then root (used by Ctags).
  set complete=.,w,b,u,i          " Keyword completion (don't search the tag file).
  set nofoldenable                " No text folding.
  set shortmess=I                 " Don't show Vim's welcome message.
  set shortmess+=a                " Make the save message shorter. Helps avoid the 'Hit ENTER to continue' message.
  set modelines=0                 " I don't use modelines and it's apparently a potential security hazard.
  set cryptmethod=blowfish2       " Vim's default (zip) is poor. Note: I prefer AES256 via GnuPG.

  " Configure term color support.
  if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
    set t_Co=256
  endif

  " Open new split panes to the bottom and right.
  set splitbelow
  set splitright

  " Disable all error whistles.
  set noerrorbells visualbell t_vb=

  " Backups
  if isdirectory($HOME . '/.vim/.tmp') == 0
    :silent !mkdir -m 700 -p ~/.vim/.tmp > /dev/null 2>&1
  endif
  set backup
  set backupdir=~/.vim/.tmp

  " I never use these...
  set noswapfile

  " Resize splits when Vim is resized.
  autocmd VimResized * wincmd =

"=== UI
  " Status Line
  set laststatus=2              " Always show a status line.
  set statusline=%f\ %m\ %r     " file path, modified status, read-only status
  set statusline+=\ Line:%l/%L  " current line / all lines
  set statusline+=\ Buf:%n      " buffer number

  " GUI
  if has('gui_running')
    set lines=35 columns=135    " Default window size.
    set guioptions-=m           " Remove menubar.
    set guioptions-=T           " Remove toolbar.
    set guicursor+=a:blinkon0   " Disable cursor blinking.
  endif

  " Visually define an 80 character limit for the active window.
  set colorcolumn=80
  " autocmd! - Remove all autocommands for the current group.
  augroup ColorColumnToggle
    autocmd!
    autocmd WinEnter * set colorcolumn=80
    autocmd WinLeave * set colorcolumn=0
  augroup END

"=== Search
  set nohlsearch      " Turn off highlight matching.
  set incsearch       " Incremental searching
  set ignorecase      " Searches are case insensitive...
  set smartcase       " ...unless they contain at least one capital letter.

"=== Whitespace
  set autoindent      " Turn on autoindenting.
  set nowrap          " Don't wrap lines.
  set expandtab       " Insert spaces instead of tabs when <Tab> is pressed.
  set shiftwidth=2    " Set the indentation width for < and >.
  set tabstop=2       " Make 2 spaces behave like a tab.
  set softtabstop=2

"=== Key Mappings
  " Change the leader key from \ to ,
  let mapleader=','

  " Use jk instead of <Esc> to enter Normal mode.
  inoremap jk <Esc>

  " Typos
  " Never open `man` documentation for a word.
  nnoremap <S-k> <Nop>
  " Never browse command history.
  nnoremap q: <Nop>
  vnoremap q: <Nop>
  " Never browse search history.
  nnoremap q/ <Nop>
  vnoremap q/ <Nop>

  " Remap arrow keys to navigate buffers and tabs.
  nnoremap <left> :bprev<CR>
  nnoremap <right> :bnext<CR>
  nnoremap <up> :tabnext<CR>
  nnoremap <down> :tabprev<CR>

  " Reselect visual block after indent/outdent.
  vnoremap < <gv
  vnoremap > >gv

  " Swap two words.
  nnoremap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

  " qq to record, Q to replay.
  nnoremap Q @q

  " Quickly reload .vimrc
  nnoremap <Leader>r :source $MYVIMRC<CR>:echo "~/.vimrc reloaded"<CR>

"=== Prose

  autocmd Filetype {text,markdown} call SetProseOptions()
  function! SetProseOptions()
    " Fix the current misspelling and jump to the next.
    nnoremap <C-f> 1z=]s

    " Use \d on a word to look it up in Dictionary.app.
    nnoremap <silent> <Leader>d :!open dict://<cword><CR><CR>

    " Text to Speech on the current visual selection.
    vnoremap <Leader>s :w<Home>silent <End> !say <CR>

    " Quickly insert today's timestamp.
    iabbrev <buffer> xdate <C-r>=strftime("%m/%d/%Y %H:%M:%S (%Z)")<CR>

    setlocal spell textwidth=80 softtabstop=4 tabstop=4 shiftwidth=4

    syntax match TextFileNoSpell "\S*\.\(txt\|rb\|sh\)" contains=@NoSpell

    syntax region HtmlCommentNoSpell start="<!--" end="-->" oneline contains=@NoSpell

    syntax match EmailNoSpell '<\?\w\+@\w\+\.\w\+>\?' contains=@NoSpell

    " Don't mark URL-like things as spelling errors.
    " Credit: http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/
    syntax match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell

    " Don't count acronyms/ abbreviations as spelling errors.
    " Credit: http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/
    syntax match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell
  endfunction

"=== Wild Mode (command-line completion)
  set wildmenu
  set wildmode=list:longest,full
  set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
  " Ignore archive files.
  set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
  " Ignore Bundler and SASS cache.
  set wildignore+=*/vendor/gems/*,*/vendor/bundle/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
  " Ignore node.js modules.
  set wildignore+=*/node_modules/*
  " Ignore temp and backup files.
  set wildignore+=*.swp,*~,._*

"=== Files
  " Treat .es6 files as JavaScript.
  autocmd BufNewFile,BufRead *.es6 set filetype=javascript
  " Python PEP8 4 space indent
  autocmd FileType python setlocal softtabstop=4 tabstop=4 shiftwidth=4
  " Treat .md files as Markdown.
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown

"=== Misc
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler.
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Remove whitespace at the end of lines while maintaining cursor position.
  function! <SID>StripTrailingWhitespaces()
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    call cursor(l, c)
  endfunction
  autocmd FileType * autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

  " Open a file in Google Chrome - OS X only.
  function! OpenFileInChrome()
    exec 'silent !open -a "Google Chrome" "%"'
    redraw!
  endfunction
  command! Chrome call OpenFileInChrome()

  " Don't auto-comment the next line on Enter.
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  " Create a tags file.
  function! CreateCtagsFile()
    exec 'silent !ctags .'
    redraw!
  endfunction
  command! Ctags call CreateCtagsFile()

  " Allow saving with sudo permission.
  function! SudoSaveFile()
    exec 'silent :w !sudo tee > /dev/null %'
  endfunction
  command! SudoSave call SudoSaveFile()

  " Refresh all buffers.
  function! RefreshAllBuffers()
    set noconfirm
    bufdo e!
    syntax enable  " Trigger buffers to highlight syntax. `bufdo e!` apparently turns it off.
    set confirm
  endfunction
  command! BufRefresh call RefreshAllBuffers()

  " Daily Journal
  function! TodaysJournalEntry()
    let journal_entry_dir = $USTASB_NOTES_DIR_PATH . '/ustasb/journal/entries/'
    let entry_path = journal_entry_dir . strftime('%Y-%m-%d') . '.md.asc'

    " Ensure the journal directory exists.
    exec "silent !mkdir -p " . journal_entry_dir

    " Open the entry.
    exec "e " . entry_path
  endfunction
  nnoremap <silent> <Leader>j :call TodaysJournalEntry()<CR>

"=== FZF
  " Search through all files recursively.
  nnoremap <silent> <Leader>f :FZF! --reverse<CR>

  " MRU
  " Credit: https://github.com/junegunn/fzf/wiki/Examples-(vim)#simple-mru-search
  nnoremap <silent> <Leader>m :call fzf#run({
  \   'source': v:oldfiles,
  \   'sink' : 'e',
  \   'options' : '--reverse',
  \ })<CR>

  " Ctags
  " Credit: https://github.com/junegunn/fzf/wiki/Examples-(vim)#jump-to-tags
  command! -bar FZFTags if !empty(tagfiles()) | call fzf#run({
  \   'source': "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
  \   'sink': 'tag',
  \   'options': '--reverse',
  \ }) | else | echo 'Preparing tags' | call CreateCtagsFile() | FZFTag | endif
  nnoremap <silent> <Leader>t :FZFTags<CR>

  " Search buffers
  " Credit: https://github.com/junegunn/fzf/wiki/Examples-(vim)#select-buffer
  function! s:buflist()
    redir => ls
    silent ls
    redir END
    return split(ls, '\n')
  endfunction

  function! s:bufopen(e)
    execute 'buffer' matchstr(a:e, '^[ 0-9]*')
  endfunction

  nnoremap <silent> <Leader>b :call fzf#run({
  \   'source': reverse(<sid>buflist()),
  \   'sink': function('<sid>bufopen'),
  \   'options': '--reverse',
  \ })<CR>

  " Notes
  nnoremap <silent> <Leader>n :call fzf#run({
  \   'source': 'find $USTASB_NOTES_DIR_PATH/*',
  \   'sink' : 'e',
  \   'options' : '--reverse',
  \ })<CR>

"=== Plugin Settings
  " Base16 color schemes
  if $ITERM_PROFILE == 'Pencil Light'
    let g:pencil_gutter_color = 1

    set background=light
    silent! colorscheme pencil

    " These colors are mapped to iTerm's 16 colors.
    hi ColorColumn  ctermbg=255
    hi StatusLine   ctermfg=15 ctermbg=4 cterm=bold " active
    hi StatusLineNC ctermfg=8  ctermbg=7 cterm=NONE " inactive
  else
    set background=dark
    silent! colorscheme base16-tomorrow

    " These colors are mapped to iTerm's 16 colors.
    hi ColorColumn  ctermbg=10
    hi StatusLine   ctermfg=0 ctermbg=7  cterm=bold " active
    hi StatusLineNC ctermfg=8 ctermbg=11 cterm=NONE " inactive
  endif

  " Andy Wokula's HTML Indent
  let g:html_indent_inctags = 'html,body,head,tbody'
  let g:html_indent_script1 = 'inc'
  let g:html_indent_style1 = 'inc'

  " vim-javascript
  let g:javascript_ignore_javaScriptdoc = 1

  " vim-coffee-script
  hi link coffeeSpaceError NONE  " Don't highlight trailing whitespace

  " RSpec.vim
  autocmd FileType ruby nnoremap <Leader>s :call RunNearestSpec()<CR>
  autocmd FileType ruby nnoremap <Leader>S :call RunCurrentSpecFile()<CR>

  " Vimux
  let g:rspec_command = 'call VimuxRunCommand("bundle exec rspec {spec}")'

  " NERD Tree
  let NERDTreeIgnore=['\.o$', '.DS_Store', 'Icon']
  let NERDTreeShowHidden=1
  nnoremap <C-n> :NERDTreeToggle<CR>
  nnoremap <Leader>g :NERDTreeFind<CR>

  " Vim Signify
  let g:signify_vcs_list = ['git']
  let g:signify_realtime = 0

  " Vim Maximizer
  nnoremap <C-W>o :MaximizerToggle<CR>
  " Override the default and remap recursively.
  nmap <C-W><C-O> <C-W>o
  vmap <C-W><C-O> <C-W>o
  imap <C-W><C-O> <C-W>o

  " Ack.vim
  let g:ackprg = 'ag --hidden --vimgrep --smart-case'
  let g:ack_lhandler = 'topleft lopen'
  let g:ack_qhandler = 'topleft copen'
  cnoreabbrev Ag Ack
  cnoreabbrev AG Ack

  " Goyo.vim
  nnoremap <Leader>z :Goyo<CR>
  let g:goyo_width = 120
  let g:goyo_height = 100

  " Vim-Commentary
  vnoremap <Leader>c :Commentary<CR>
  nnoremap <Leader>c :Commentary<CR>

  " Vim-JSX
  let g:jsx_ext_required = 0

  " Vim Markdown Preview
  let g:vim_markdown_preview_pandoc = 1
  let g:vim_markdown_preview_browser = 'Google Chrome'
  let g:vim_markdown_preview_pandoc_args = '--smart --to=html5 --self-contained --highlight-style=haddock --css /Users/ustasb/dotfiles/markdown_css/github.css'

  " Vim Voom
  let g:voom_python_versions = [3, 2]
  let g:voom_tree_placement = 'left'
  let g:voom_tree_width = 40
  let g:voom_default_mode = 'markdown'
  nnoremap <Leader>o :VoomToggle<CR>

  " Vim GnuPG
  let g:GPGExecutable = 'gpg --trust-model always'
  let g:GPGPreferArmor = 1
  let g:GPGUseAgent = 1
  let g:GPGPreferSign = 1
  let g:GPGUsePipes = 1
  let g:GPGFilePattern = '*.asc' " ASCII armored files
  let g:GPGDefaultRecipients=[
    \"Brian Ustas <brianustas@gmail.com>",
  \]
  " HACK: Without, two columns are highlighted on the second line upon startup...
  autocmd VimEnter *.asc execute(':redraw!')

  " Scratch.vim
  let g:ScratchFileName = $USTASB_NOTES_DIR_PATH . '/scratch.md'
  nnoremap <Leader>a :ScratchToggle<CR>

  " vim-sneak
  let g:sneak#label = 1
  map f <Plug>Sneak_s
  map F <Plug>Sneak_S

"=== Local Customizations

  if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
  endif
