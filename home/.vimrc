" Brian Ustas's .vimrc
"
" Tested with Neovim on OS X.
"
" Expected Installs:
" - Git
" - Ruby and RSpec
" - tmux (http://tmux.sourceforge.net)
" - rg (https://github.com/BurntSushi/ripgrep)
" - ctags (https://github.com/universal-ctags/ctags)
" - fzf (https://github.com/junegunn/fzf)
" - pandoc (https://pandoc.org)

" === vim-plug === {{{

  call plug#begin('~/.vim/plugged')
    Plug 'itchyny/lightline.vim'

    " editing
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-commentary', { 'on': 'Commentary' }
    Plug 'lifepillar/vim-mucomplete'
    Plug 'tpope/vim-surround'
    Plug 'junegunn/vim-easy-align', { 'on': 'EasyAlign' }

    " snippets
    Plug 'sirver/UltiSnips'

    " colors
    Plug 'ustasb/gruvbox'
    Plug 'lilydjwg/colorizer', { 'on': 'ColorToggle' }

    " git
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'

    " prose
    Plug 'ustasb/vim-markdown', { 'for': 'markdown' }
    Plug 'reedes/vim-litecorrect', { 'for': ['markdown', 'text'] }
    Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }

    " search
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " Don't use vim-plug's lazy loading here! :Ack on text below the cursor
    " won't work the first time.
    Plug 'mileszs/ack.vim'

    " tmux
    Plug 'benmills/vimux'
    Plug 'christoomey/vim-tmux-navigator'

    " web
    Plug 'othree/html5-syntax.vim', { 'for': 'html' }
    Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
    Plug 'chr4/nginx.vim', { 'for' : 'nginx' }

    " ruby
    Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
    Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }

    " python
    Plug 'vim-python/python-syntax', { 'for': 'python' }
    Plug 'davidhalter/jedi-vim', { 'for': 'python' }
    Plug 'tmhedberg/SimpylFold', { 'for': 'python' }

    " misc
    Plug 'w0rp/ale'
    Plug 'szw/vim-maximizer', { 'on': 'MaximizerToggle' }
    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
    Plug 'lvht/tagbar-markdown'
    Plug 'justinmk/vim-dirvish'
    Plug 'justinmk/vim-sneak'
    Plug 'jamessan/vim-gnupg'
    Plug 'tpope/vim-repeat'
    Plug 'tyru/open-browser.vim'
  call plug#end()

" }}}

" === Basic === {{{

  filetype plugin indent on
  syntax enable

  " file format (relevant to line ending type)
  " Unix based systems and Mac OS X+.
  set ffs=unix,dos
  " Set default encoding to UTF-8.
  set encoding=utf-8
  " English spelling
  set spelllang=en
  " Custom spellfile for `zg` and `zw`.
  set spellfile=$USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/settings/vim/vim-spell-en.utf-8.add
  " Default spellfile is located at: ~/.vim/spell/en.utf-8.spl

  " Enable mouse support for all modes.
  set mouse=a
  " Make backspace work like most other apps.
  set backspace=indent,eol,start
  " Merge Vim and OS clipboard.
  " https://stackoverflow.com/a/30691754/1575238
  set clipboard=unnamed,unnamedplus

  " Keep 100 lines of command-line history.
  set history=100
  " Keep 100 lines of undo history.
  set undolevels=100

  " Set the tag file search order: current directory then root (used by Ctags).
  set tags=./tags;/

  " Allow unsaved background buffers.
  set hidden
  " I don't use modelines and it's apparently a potential security hazard.
  set modelines=0
  " Prevent Shift-O delay in terminal.
  set ttimeoutlen=100

  if has('nvim')
    " Required to save files on mounted volumes.
    set nofsync
  else
    " Vim's default (zip) is poor. Prefer AES256 via GnuPG.
    set cryptmethod=blowfish2
  endif

" }}}

" === Backups === {{{

  " I never use these.
  set noswapfile

  if isdirectory($HOME . '/.vim/.backup') == 0
    :silent !mkdir -m 700 -p ~/.vim/.backup > /dev/null 2>&1
  endif

  set backup
  set backupdir=~/.vim/.backup
  set backupcopy=auto
  " Make a backup before overwriting the current buffer.
  set writebackup
  " Don't back up my documents.
  set backupskip+=*/documents/*
  " Don't back up OS X's tmp/.
  set backupskip+=/private/tmp/*

  augroup AG_VimBackup
    autocmd!
    " Ensure unique backup names.
    " solves: https://stackoverflow.com/a/26779916/1575238
    autocmd BufWritePre * let &backupext = '~' . substitute(expand('%:p:h'), '/', '%', 'g')
  augroup END

" }}}

" === Colors === {{{

  " truecolor
  set t_Co=256
  set termguicolors

  if $ITERM_PROFILE == 'GruvboxLight' || has('gui_running')
    set background=light
  else
    set background=dark
  endif

  let g:gruvbox_bold = 1
  let g:gruvbox_italic = 1
  let g:gruvbox_invert_tabline = 0
  let g:gruvbox_invert_selection = 0
  let g:gruvbox_sign_column = 'bg1'
  let g:gruvbox_color_column = 'bg1'
  let g:gruvbox_number_column = 'bg1'
  let g:gruvbox_guisp_fallback = 'fg' " Make misspellings clearer.
  let g:gruvbox_contrast_dark = 'medium'
  let g:gruvbox_contrast_light = 'hard'
  let g:bu_ignore_capitalization = 1

  silent! colorscheme gruvbox

" }}}

" === UI === {{{

  " Change the title of the terminal/tab with the file name.
  set title
  set titlestring=%t

  " Don't show Vim's welcome message.
  set shortmess=I
  " Make the save message shorter. Helps avoid the 'Hit ENTER to continue' message.
  set shortmess+=at
  " Don't show completion messages.
  set shortmess+=c

  " Always show the status line.
  set laststatus=2
  " better splits
  set splitbelow
  set splitright
  " vertical split character
  set fillchars+=vert:│
  " Don't show pressed keys in the statusline.
  set noshowcmd

  " text folding
  set foldenable
  " Open all folds by default.
  set foldlevel=20
  set foldmethod=marker
  set foldmarker={{{,}}}
  " Only allow two levels of nesting.
  set foldnestmax=2
  " toggle folds
  nnoremap <silent> <Space> @=(foldlevel('.') ? 'za' : "\<Space>")<CR>
  nnoremap <silent> <C-Space> :call ToggleAllFolds()<CR>

  " GUI
  if has('gui_running')
    set antialias
    set linespace=1 " line height
    set guifont=SF\ Mono\ Regular:h12
    " remove toolbar, menubar and scrollbar
    set guioptions=
    " disable cursor blinking
    set guicursor+=a:blinkon0
    " disable all error whistles
    set noerrorbells visualbell t_vb=
  else
    " Performance tweaks for terminal Vim...

    " Don't match parentheses or brackets.
    " let loaded_matchparen=1
    " set noshowmatch

    " not needed / expensive to render
    set nocursorline
    set nocursorcolumn
    set norelativenumber

    " Scroll 10 lines at bottom/ top.
    " set scrolljump=10
  endif

  " Resize splits when Vim is resized.
  augroup AG_VimResize
    autocmd!
    autocmd VimResized * wincmd =
  augroup END

" }}}

" === Search === {{{

  " Turn off highlight matching.
  set nohlsearch
  " incremental searching
  set incsearch
  " Searches are case insensitive...
  set ignorecase
  " ...unless they contain at least one capital letter.
  set smartcase

" }}}

" === Whitespace === {{{

  " enable auto-indenting
  set autoindent
  " Don't wrap lines.
  set nowrap
  " Insert spaces instead of tabs when <Tab> is pressed.
  set expandtab
  " Set the indentation width for < and >.
  set shiftwidth=2
  " Make 2 spaces behave like a tab.
  set tabstop=2
  set softtabstop=2

" }}}

" === Key Mappings === {{{

  " Change the leader key from \ to ,
  let mapleader=','

  " Use jk instead of <Esc> to enter Normal mode.
  inoremap jk <Esc>
  inoremap JK <Esc>

  " typos
  cnoreabbrev aw wa

  " Disable `man` documentation for a word.
  nnoremap <S-k> <Nop>
  vnoremap <S-k> <Nop>
  " Disable command and search history. Replaced with fzf.
  nnoremap Q <Nop>

  " Reselect visual block after indent/outdent.
  vnoremap < <gv
  vnoremap > >gv

  " Swap two words.
  nnoremap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

  " Quickly reload .vimrc.
  nnoremap <Leader>r :source $MYVIMRC<CR>:echo "~/.vimrc reloaded"<CR>

  " beginning of line / end of line
  inoremap <C-a> <Esc>I
  inoremap <C-e> <Esc>A

  " Allows pasting over content without changing the copy buffer.
  " http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
  xnoremap p "_dP

  if has('nvim')
    " Neovim terminal
    tnoremap jk <C-\><C-n>
  endif

" }}}

" === Prose === {{{

  function! SetProseOptions()
    " Fix common typos.
    call litecorrect#init()

    " mucomplete's `dict` completion requires `dictionary` set locally.
    setlocal dictionary=$HOME/dotfiles/vim/en_popular.txt

    setlocal spell textwidth=65 softtabstop=4 tabstop=4 shiftwidth=4

    " Fix the previous misspelling.
    nnoremap <buffer> <C-f> [s1z=<C-o>
    inoremap <buffer> <C-f> <C-g>u<Esc>[s1z=`]A<C-g>u

    " Open a word in Dictionary.app.
    nnoremap <buffer> <Leader>d :silent !open dict://<cword><CR>

    " Surround cursor word with backticks indicating code.
    " create mark x, add backticks, go back to mark x, move right one char
    nnoremap <buffer> <Leader>C :normal mxysiW``xl<CR>

    " Text to Speech on the current visual selection.
    vnoremap <buffer> <Leader>s :w<Home>silent <End> !say<CR>

    " Preface each line with '- ' for quickly creating lists.
    vnoremap <buffer> <Leader>l :s/^\(\s*\)/\1- /<CR>

    " Adds periods and capitalization.
    " create mark x, select line, professionalize, go back to mark x
    nnoremap <buffer> <Leader>t :execute('normal mxV,t`x')<CR>
    vnoremap <buffer> <Leader>t :!ruby ~/dotfiles/scripts/professionalize_text.rb<CR>

    nnoremap <buffer> <C-p> :call RenderMarkdownInChrome()<CR>

    syntax match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell

    if expand('%:t') == 'todo.md'
      setlocal textwidth=0
      command! -buffer -nargs=* Done call LogCompletedTask(<f-args>)
    end
  endfunction

  augroup AG_ProseOptions
    autocmd!
    autocmd Filetype {text,markdown} call SetProseOptions()
  augroup END

" }}}

" === Wild Mode (command-line completion) === {{{

  set wildmenu
  set wildmode=list:longest,list:full
  set wildignore+=*.csv,*.tsv,*.json,*.h4,*.h5
  set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
  set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" }}}

" === File Types === {{{

  augroup AG_FileTypeOptions
    autocmd!

    " Python
    autocmd FileType python setlocal
      \ softtabstop=4
      \ tabstop=4
      \ shiftwidth=4
  augroup END

" }}}

" === Misc Functions === {{{

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler.
  " (happens when dropping a file on gvim).
  function! ResetCursorPosition()
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal g`\""
    endif
  endfunction

  " Remove whitespace at the end of lines while maintaining cursor position.
  function! StripTrailingWhitespaces()
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    call cursor(l, c)
  endfunction

  " Open a file in Google Chrome.
  command! Chrome :!open -a "Google Chrome" %:p

  " Open a file in Tad (CSV viewer).
  command! Tad :!open -a "Tad" %:p

  " Create a tags file.
  function! CreateCtagsFile()
    let cwd = getcwd()
    silent exec('silent !ctags ' . cwd)
    echom 'Created tags file at: ' . cwd . '/tags'
  endfunction
  command! Ctags call CreateCtagsFile()

  " Allow saving with sudo permission.
  function! SudoSaveFile()
    exec 'silent :w !sudo tee > /dev/null %'
  endfunction
  command! SudoSave call SudoSaveFile()

  function! RefreshAllBuffers()
    let currBuff = bufnr("%")
    " refresh buffers
    execute 'silent! bufdo e!'
    " Go back to the original buffer.
    execute 'buffer ' . currBuff
    " bufdo e! turns syntax highlighting off for efficiency.
    syntax enable
  endfunction
  command! BufRefresh call RefreshAllBuffers()

  " Execute the current file with the correct interpreter.
  function! ExecuteFile()
    let interpreter = &filetype == 'ruby' ? 'ruby' :
      \ &filetype == 'python' ? 'python' :
      \ &filetype == 'javascript' ? 'node' :
      \ &filetype == 'javascript.jsx' ? 'node' :
      \ &filetype == 'sh' ? 'bash' : ''

    if interpreter == ''
      echom "No interpreter found for filetype '" . &filetype . "'!"
    else
      exec '!' . interpreter . ' %'
    endif
  endfunction
  nnoremap <Leader>e :call ExecuteFile()<CR>

  " Daily Journal
  function! TodaysJournalEntry(encrypt)
    let journal_entry_dir = $USTASB_DOCS_DIR_PATH . '/ustasb/journal/entries/'
    let entry_path = journal_entry_dir . strftime('%Y-%m-%d') . '.md' . (a:encrypt ? '.asc' : '')
    exec 'e ' . entry_path
  endfunction
  command! J call TodaysJournalEntry(0)
  command! JE call TodaysJournalEntry(1)

  " Convert Pandoc markdown to Github flavored markdown.
  function! PandocMarkdownToGFM()
    if &filetype == "markdown"
      %s/^#/##/g " Increase heading levels.
      %s/^%/#/g " Convert the title header.
      echomsg "Converted to Github flavored markdown!"
    else
      echomsg "You're not in a markdown file!"
    endif
  endfunction
  command! PandocMarkdownToGFM call PandocMarkdownToGFM()

  " credit: https://github.com/arithran/vim-delete-hidden-buffers
  function! CloseHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
      silent execute 'bwipeout!' buf
    endfor
  endfunction
  command! CloseHiddenBuffers call CloseHiddenBuffers()

  " Open / close all folds.
  function! ToggleAllFolds()
    if get(g:, 'folds_open', 1) == 1
      let g:folds_open = 0
      normal zM
    else
      let g:folds_open = 1
      normal zR
    endif
    " center the cursor
    normal zz
  endfunction

  " Timestamp, log and delete the task at the cursor.
  function! LogCompletedTask(...)
    let task = getline('.')
    " remove list markers
    let task = substitute(task, '^\s*[-+]\s*', '', '')
    " remove trailing whitespace
    let task = substitute(task, '\s*$', '', '')

    " ISO8601
    let days_ago = (a:0 == 0) ? 0 : a:1
    let epoch_secs = system('date -v-' . days_ago . 'd +%s')
    let timestamp = strftime('%FT%T%z', epoch_secs)
    let json = json_encode({ 'task': task, 'timestamp': timestamp })

    " log the task
    let done_log = $USTASB_DOCS_DIR_PATH . '/ustasb/done.log'
    silent exec('!echo ' . shellescape(json, 1) . ' >> ' . done_log)
    silent exec('!ruby ~/dotfiles/scripts/create_done_md.rb')

    " delete the task (don't cut)
    normal \"_dd

    echomsg 'Task Done! ' . json
  endfunction

  function! ToggleAutoComplete()
    if exists(':MUcompleteAutoOn') == 0
      return
    endif

    if &filetype == 'markdown'
      set completeopt-=noselect
      MUcompleteAutoOff
    else
      set completeopt+=noselect
      MUcompleteAutoOn
    end
  endfunction

  function! RenderMarkdownInChrome()
    call system('ruby $HOME/dotfiles/pandoc/markdown_to_html.rb'
      \ . ' --input ' . expand('%:p')
      \ . ' --output /tmp/pandoc-markdown-preview.html --open-in-chrome'
      \ )
  endfunction

  " Open the cursor's word in Dash using Search Profiles.
  " https://kapeli.com/dash_guide#searchProfiles
  function! OpenInDash()
    let g:ft_dash_profile_map = get(g:, 'ft_dash_profile_map', {
      \ 'vim'            : 'vim',
      \ 'python'         : 'py',
      \ 'ruby'           : 'rb',
      \ 'javascript'     : 'js',
      \ 'javascript.jsx' : 'js',
      \ })
    let dash_profile = get(g:ft_dash_profile_map, &filetype, 'default')
    let dash_uri = 'dash://' . dash_profile . ':' . expand('<cword>')
    silent exec('!open ' . dash_uri)
  endfunction
  nnoremap <Leader>d :call OpenInDash()<CR>

  " .vimrc
  command! Vimrc :e ~/dotfiles/home/.vimrc
  command! V Vimrc

  " .zshrc
  command! Zshrc :e ~/dotfiles/home/.zshrc
  command! Z Zshrc

  " todo.md
  function! OpenTodo()
    if expand('%:t') == 'todo.md'
      return
    endif

    let is_open = bufexists(bufname('todo.md'))

    e $USTASB_DOCS_DIR_PATH/ustasb/todo.md

    if !is_open
      " Fold everything except Tasks and Today.
      call ToggleAllFolds()

      call search('^# Overview', 'cw')
      normal zo
      call search('^## Q2', 'cw')
      normal zA
      call search('^# This Week', 'cw')
      normal zo
      call search('^## Tasks', 'cw')
      normal zA
      call search('^## Today', 'cw')
      normal zA
      " center the cursor
      normal zz
    endif
  endfunction
  command! Todo call OpenTodo()
  command! T Todo

  " scratch.md
  command! Scratch :e $USTASB_DOCS_DIR_PATH/scratch.md
  command! S Scratch

  " quickly quit
  command! Q :qa
  nnoremap Q :qa<CR>

  augroup AG_Misc
    autocmd!

    autocmd BufEnter * call ToggleAutoComplete()

    autocmd BufReadPost * call ResetCursorPosition()

    autocmd FileType * autocmd BufWritePre <buffer> call StripTrailingWhitespaces()

    " Don't auto-comment the next line on Enter.
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  augroup END

" }}}

" === Plugin Settings === {{{

  " vim-javascript {{{
  let g:javascript_ignore_javaScriptdoc = 1
  augroup AG_JavaScriptFolding
    autocmd!
    autocmd FileType javascript,javascript.jsx setlocal foldmethod=syntax
  augroup END
  " }}}

  " vim-ruby {{{
  let g:ruby_spellcheck_strings = 0
  let g:ruby_indent_block_style = 'do'
  " Uncomment the below line if Ruby files become sluggish. Folding won't work.
  let g:ruby_no_expensive = 1
  let g:ruby_fold = 1
  let g:ruby_foldable_groups = 'def'
  " Enable omni completion.
  let g:rubycomplete_buffer_loading = 1
  " }}}

  " RSpec.vim {{{
  augroup AG_Rspec
    autocmd!
    autocmd FileType ruby nnoremap <buffer> <Leader>s :call RunNearestSpec()<CR>
    autocmd FileType ruby nnoremap <buffer> <Leader>S :call RunCurrentSpecFile()<CR>
  augroup END
  " }}}

  " Vimux {{{
  let g:rspec_command = 'call VimuxRunCommand("bundle exec rspec {spec}")'
  " }}}

  " dirvish.vim {{{
  let g:dirvish_mode = ':sort ,^.*[\/],' " directories first
  " }}}

  " Vim Signify {{{
  let g:signify_vcs_list = ['git']
  let g:signify_realtime = 0
  " }}}

  " Vim Fugitive {{{
  " Slows down my C-r command mode mapping.
  let g:fugitive_no_maps = 1
  " }}}

  " Vim Maximizer {{{
  nnoremap <C-W>o :MaximizerToggle<CR>
  " }}}

  " Ack.vim {{{
  let g:ackprg = 'rg --hidden --vimgrep --smart-case'
  let g:ack_lhandler = 'topleft lopen'
  let g:ack_qhandler = 'topleft copen'
  cnoreabbrev Ag Ack!
  cnoreabbrev AG Ack!
  cnoreabbrev ag Ack!
  " Agn to search my documents.
  command! -nargs=1 Agn Ack! <f-args> $USTASB_DOCS_DIR_PATH
  cnoreabbrev AGn Agn
  " }}}

  " Goyo.vim {{{
  nnoremap <Leader>z :Goyo<CR>
  let g:goyo_width = 100
  let g:goyo_height = '95%'
  function! s:goyo_enter()
    " Show the vertical splits.
    setlocal fillchars=vert:│
    highlight! link VertSplit GruvboxBg1
  endfunction
  function! s:goyo_leave()
    " HACK: Without, after leaving Goyo, my fzf statusline
    " customizations are replaced by the lightline statusline.
    autocmd! FileType fzf doautocmd User FzfStatusLine
  endfunction
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
  " }}}

  " Vim-Commentary {{{
  vnoremap <Leader>c :Commentary<CR>
  nnoremap <Leader>c :Commentary<CR>
  " }}}

  " Vim Markdown {{{
  let g:markdown_folding = 1
  " }}}

  " Tagbar {{{
  let g:tagbar_width = 30
  let g:tagbar_silent = 1
  let g:tagbar_compact = 1
  let g:tagbar_autofocus = 1
  let g:tagbar_iconchars = ['▸', '▾']
  let g:tagbar_sort = 0 " Don't sort alphabetically.
  let g:tagbar_map_togglefold = '<Space>'
  nnoremap <Leader>o :TagbarToggle<CR>
  let g:tagbar_status_func = 'TagbarStatusFunc'
  function! TagbarStatusFunc(current, sort, fname, ...) abort
  	let g:lightline.fname = a:fname
  	return lightline#statusline(0)
  endfunction
  " }}}

  " Vim GnuPG {{{
  let g:GPGExecutable = 'gpg --trust-model always'
  let g:GPGPreferArmor = 1
  let g:GPGUseAgent = 1
  " Only signs upon creation, not after editing.
  " Turning it off - too inconsistent. Even after forking and fixing, it's too slow.
  let g:GPGPreferSign = 0
  let g:GPGUsePipes = 1
  let g:GPGFilePattern = '*.asc' " ASCII armored files
  let g:GPGDefaultRecipients = ['Brian Ustas <brianustas@gmail.com>']
  " }}}

  " vim-sneak {{{
  let g:sneak#label = 1
  let g:sneak#use_ic_scs = 1 " Respect ignorecase and smartcase.
  map s <Plug>Sneak_s
  map S <Plug>Sneak_S
  " }}}

  " ALE {{{
  let g:ale_enabled = 1
  let g:ale_completion_enabled = 0
  let g:ale_sign_error = '✖' " ✘
  let g:ale_sign_warning = '✦' " ⚑
  let g:ale_lint_on_save = 1
  let g:ale_lint_on_enter = 1
  let g:ale_lint_on_text_changed = 0
  let g:ale_lint_on_filetype_changed = 1
  let g:ale_linters_explicit = 1
  let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'python': ['flake8'],
    \ }
  " }}}

  " fzf.vim {{{
  let g:fzf_command_prefix = 'Fzf'
  let g:fzf_layout = { 'up': '~35%' }
  let g:fzf_colors = {
    \ 'prompt':   ['fg', 'GruvboxAquaBold'],
    \ 'spinner':  ['fg', 'Comment'],
    \ 'info':     ['fg', 'Comment'],
    \ 'pointer':  ['fg', 'Statement'],
    \ 'fg':       ['fg', 'Normal'],
    \ 'fg+':      ['fg', 'Normal'],
    \ 'bg+':      ['bg', 'CursorLine'],
    \ 'hl+':      ['fg', 'Statement'],
    \ 'hl':       ['fg', 'Statement']
    \ }
  " https://github.com/junegunn/fzf.vim#status-line-neovim
  " empty status line
  augroup AG_MyFZF
    autocmd!
    autocmd User FzfStatusLine setlocal statusline=%#CursorLine#
  augroup END
  " Search recursively through all files in CWD.
  nnoremap <silent> <Leader>f :FzfFiles<CR>
  " buffers
  nnoremap <silent> <Leader>F :FzfBuffers<CR>
  " most recently used
  nnoremap <silent> <Leader>m :FzfHistory<CR>
  " ctags
  nnoremap <silent> <Leader>t :FzfTags<CR>
  " documents
  nnoremap <silent> <Leader>n :FzfFiles $USTASB_DOCS_DIR_PATH<CR>
  " snippets via UltiSnips
  nnoremap <silent> <Leader>u :FzfSnippets<CR>
  " search history
  nnoremap <silent> q/ :FzfHistory/<CR>
  " command history
  nnoremap <silent> q: :FzfHistory:<CR>
  " }}}

  " auto-pairs {{{
  let g:AutoPairsShortcutToggle = '' " disable
  let g:AutoPairsMapCh = 0
  let g:AutoPairsMapSpace = 0
  let g:AutoPairsCenterLine = 0
  " }}}

  " vim-mucomplete {{{
  let g:mucomplete#enable_auto_at_startup = 0
  let g:mucomplete#buffer_relative_paths = 1
  let g:mucomplete#no_popup_mappings = 1 " Conflicts with my C-e (beginning-of-line) mapping.

  " max number of suggestions
  set pumheight=15

  " . : current buffer
  " w : buffers from other windows
  " b : buffers from buffer list
  set complete=.,w,b
  set completeopt=menu,menuone,noselect
  let g:mucomplete#always_use_completeopt = 1

  " :h mucomplete-methods
  " c-p / c-n respects Vim's `set complete`.
  let g:mucomplete#chains = {}
  let g:mucomplete#chains.default  = ['path', 'c-p', 'tags', 'omni', 'ulti']
  let g:mucomplete#chains.vim      = ['path', 'cmd', 'c-p',  'ulti']
  let g:mucomplete#chains.markdown = ['path', 'c-p', 'dict', 'ulti']
  let g:mucomplete#chains.python   = ['path', 'c-p', 'tags', 'ulti']

  " Ruby/Python: Trigger completion after period (e.g. `obj.`).
  let s:py_rb_omni_cond = { t -> t =~# '\m\k\%(\k\|\.\)$' }
  let g:mucomplete#can_complete = {
    \ 'python' : { 'omni': s:py_rb_omni_cond },
    \ 'ruby'   : { 'omni': s:py_rb_omni_cond },
    \ }

  " c-h or c-j to cycle through completion modes (once the popup menu is open).
  " c-h workaround: https://github.com/lifepillar/vim-mucomplete/issues/55
  imap <C-h> <Plug>(MUcompleteCycBwd)
  inoremap <silent> <Plug>(MUcompleteBwdKey) <C-h>

  function! s:SmartCR()
    if pumvisible()
      if empty(v:completed_item) " Nothing selected?
        " Hack: Without, if you type 'Monday' and 'Monday' is automatically
        " suggested by mu-complete, and then press ENTER without selecting the
        " suggestion, 'nday' will be chopped from 'Monday'. It only happens
        " when autocomplete is enabled and completeopt=noselect. This hack
        " first exits the completion window via Escape.
        return "\<Esc>a" . mucomplete#popup_exit("\<CR>")
      else
        let snippet = UltiSnips#ExpandSnippet()
        if g:ulti_expand_res > 0
          return snippet
        else
          return mucomplete#popup_exit("\<CR>")
        endif
      endif
    else
      return "\<CR>"
    endif
  endfunction
  inoremap <silent> <CR> <C-r>=<SID>SmartCR()<CR>
  " }}}

  " python-syntax {{{
  let g:python_highlight_all = 1
  let g:python_highlight_space_errors = 0
  let g:python_highlight_indent_errors = 0
  " }}}

  " jedi.vim {{{
  " Configured to work with MUcomplete.
  let g:jedi#force_py_version = 3
  let g:jedi#auto_initialization = 0
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#smart_auto_mappings = 0
  let g:jedi#completions_enabled = 0
  let g:jedi#show_call_signatures = 0 " too slow
  augroup AG_JediVim
    autocmd!
    autocmd FileType python setlocal omnifunc=jedi#completions
  augroup END
  " }}}

  " colorizer.vim (hex colorizing) {{{
  let g:colorizer_startup = 0
  let g:colorizer_nomap = 1
  " }}}

  " UltiSnips {{{
  " c-j is reserved for mucomplete.
  let g:UltiSnipsExpandTrigger = '<C-Space>'
  let g:UltiSnipsJumpForwardTrigger = '<C-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
  let g:UltiSnipsListSnippets = '<Nop>' " use FzfSnippets
  let g:UltiSnipsSnippetDirectories = [$HOME . '/dotfiles/vim/ultisnips']
  " }}}

  " openbrowser.vim {{{
  let g:netrw_nogx = 1 " Disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
  " }}}

  " lightline.vim {{{
  set noshowmode " Don't show the default mode indicator.

  let g:lightline = {
  \   'colorscheme': 'gruvbox',
  \   'enable': {
  \     'tabline': 1,
  \     'statusline': 1,
  \   },
  \   'active': {
  \     'left': [
  \       ['mode', 'paste'],
  \       ['readonly', 'filename', 'modified']
  \      ],
  \     'right': [
  \       ['lineinfo'],
  \       ['percent'],
  \       ['fileformat', 'fileencoding', 'filetype']
  \     ]
  \   },
  \   'component_function': {
  \     'mode': 'LightlineMode',
  \     'filename': 'LightlineFilename',
  \     'modified': 'LightlineModified',
  \     'fileformat': 'LightlineFileformat',
  \     'fileencoding': 'LightlineFileencoding',
  \     'filetype': 'LightlineFiletype',
  \   },
  \   'subseparator': {
  \     'left': '│',
  \     'right': '│'
  \   }
  \ }

  function! LightlineMode()
    let fname = expand('%:t')
    return &filetype == 'dirvish' ? '' :
      \ &filetype == 'tagbar' ? '' :
      \ &filetype == 'qf' ? '' :
      \ &filetype == 'fzf' ? '' :
      \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

  function! LightlineFilename()
    let fname = expand('%:t')
    return &filetype == 'dirvish' ? 'Dirvish' :
      \ &filetype == 'tagbar' ? 'Tagbar' :
      \ &filetype == 'qf' ? 'QuickFix' :
      \ &filetype == 'fzf' ? 'fzf' :
      \ fname != '' ? fname : '[No Name]'
  endfunction

  function! LightlineModified()
    return &modified ? "+" : ""
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > 80 ? &fileformat : ''
  endfunction

  function! LightlineFileencoding()
    return winwidth(0) > 80 ? (strlen(&fenc) ? &fenc : &enc) : ''
  endfunction

  function! LightlineFiletype()
    return winwidth(0) > 80 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  endfunction
  " }}}

" }}}

" === Local Customizations === {{{

  if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
  endif

" }}}
