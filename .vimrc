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

"=== vim-plug
  call plug#begin('~/.vim/plugged')
    Plug 'mhinz/vim-startify'
    Plug 'itchyny/lightline.vim'

    " editing
    Plug 'Raimondi/delimitMate'
    Plug 'tpope/vim-commentary', { 'on': 'Commentary' }
    Plug 'ajh17/VimCompletesMe'

    " colorschemes
    Plug 'morhetz/gruvbox'

    " git
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'

    " markdown
    Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }
    Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown' }
    Plug 'ustasb/vim-markdown-preview', { 'for': 'markdown' }
    Plug 'vim-voom/VOoM', { 'on': 'VoomToggle' }

    " search
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " requires rg (ripgrep)
    " Don't use vim-plug's lazy loading here! :Ack on text below the cursor
    " won't work the first time.
    Plug 'mileszs/ack.vim'

    " tmux
    Plug 'benmills/vimux'
    Plug 'christoomey/vim-tmux-navigator'

    " web
    Plug 'othree/html5-syntax.vim', { 'for': 'html' }
    Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
    Plug 'mxw/vim-jsx', { 'for': 'javascript' }
    Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

    " ruby
    Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
    Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }

    " misc
    Plug 'w0rp/ale', { 'on': 'ALEToggle' }
    Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
    Plug 'szw/vim-maximizer', { 'on': 'MaximizerToggle' }
    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'justinmk/vim-sneak'
    Plug 'jamessan/vim-gnupg'
  call plug#end()

"=== Basic
  filetype plugin indent on
  syntax enable

  " file format (relevant to line ending type)
  set ffs=unix,dos
  " Set default encoding to UTF-8.
  set encoding=utf-8
  " US English spelling
  set spelllang=en_us
  " custom spellfile
  set spellfile=$USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/settings/vim/vim-spell-en.utf-8.add

  " Enable mouse support for all modes.
  set mouse=a
  " Make backspace work like most other apps.
  set backspace=indent,eol,start
  " Merge Vim and OS clipboard.
  set clipboard=unnamedplus

  " Keep 100 lines of command-line history.
  set history=100
  " Keep 100 lines of undo history.
  set undolevels=100

  " Set the tag file search order: current directory then root (used by Ctags).
  set tags=./tags;/
  " Keyword completion (don't search the tag file).
  set complete=.,w,b,u,i

  " Allow unsaved background buffers.
  set hidden
  " I don't use modelines and it's apparently a potential security hazard.
  set modelines=0
  " Prevent Shift-O delay in terminal.
  set ttimeoutlen=100

  " ~/.vim/tmp backups
  if isdirectory($HOME . '/.vim/.tmp') == 0
    :silent !mkdir -m 700 -p ~/.vim/.tmp > /dev/null 2>&1
  endif
  set backup
  set backupdir=~/.vim/.tmp
  set noswapfile " I never use these.

  if has('nvim')
    " Required to save files on mounted volumes.
    set nofsync
  else
    " Vim's default (zip) is poor. Prefer AES256 via GnuPG.
    set cryptmethod=blowfish2
  endif

"=== Colors
  " truecolor
  set t_Co=256
  set termguicolors
  set background=dark

  let g:gruvbox_bold = 1
  let g:gruvbox_invert_tabline = 0
  let g:gruvbox_invert_selection = 0
  let g:gruvbox_sign_column = 'bg1'
  let g:gruvbox_color_column = 'bg1'
  let g:gruvbox_number_column = 'bg1'
  let g:gruvbox_guisp_fallback = 'fg' " Make misspellings clearer.
  let g:gruvbox_contrast_dark = 'medium'

  silent! colorscheme gruvbox

  " https://github.com/itchyny/lightline.vim/issues/179
  highlight! StatusLine ctermfg=237 ctermbg=237 guifg=#3c3836 guibg=#3c3836

  " https://github.com/morhetz/gruvbox/issues/175
  " Swap spell highlighting. Make errors red and warnings blue.
  highlight! SpellBad cterm=undercurl ctermfg=167 gui=undercurl guifg=#fb4934 guisp=#fb4934
  highlight! SpellCap cterm=undercurl ctermfg=109 gui=undercurl guifg=#83a598 guisp=#83a598

"=== UI
  " Change the title of the terminal/tab with the file name.
  set title
  " Don't show Vim's welcome message.
  set shortmess=I
  " Make the save message shorter. Helps avoid the 'Hit ENTER to continue' message.
  set shortmess+=a
  " Always show the status line.
  set laststatus=2
  " better splits
  set splitbelow
  set splitright
  " vertical split character
  set fillchars+=vert:│
  " Don't show pressed keys in the statusline.
  set noshowcmd
  " No text folding.
  set nofoldenable
  " block cursor
  set guicursor=
  " filename in the tabbar
  set guitablabel=%t

  " GUI
  if has('gui_running')
    " default window size
    set lines=35 columns=135
    " remove menubar
    set guioptions-=m
    " remove toolbar
    set guioptions-=T
    " disable all error whistles
    set noerrorbells visualbell t_vb=
  else
    " performance tweaks
    set lazyredraw

    " Don't match parentheses or brackets.
    let loaded_matchparen=1
    set noshowmatch

    " not needed / expensive to render
    set nocursorline
    set nocursorcolumn
    set norelativenumber

    " Scroll 10 lines at bottom/ top.
    set scrolljump=10
  endif

  " Resize splits when Vim is resized.
  augroup AG_VimResize
    autocmd!
    autocmd VimResized * wincmd =
  augroup END

"=== Search
  " Turn off highlight matching.
  set nohlsearch
  " incremental searching
  set incsearch
  " Searches are case insensitive...
  set ignorecase
  " ...unless they contain at least one capital letter.
  set smartcase

"=== Whitespace
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

"=== Key Mappings
  " Change the leader key from \ to ,
  let mapleader=','

  " Use jk instead of <Esc> to enter Normal mode.
  inoremap jk <Esc>

  " typos
  cnoreabbrev aw wa

  " Never open `man` documentation for a word.
  nnoremap <S-k> <Nop>
  " Never browse command history.
  nnoremap q: <Nop>
  vnoremap q: <Nop>
  " Never browse search history.
  nnoremap q/ <Nop>
  vnoremap q/ <Nop>

  " Reselect visual block after indent/outdent.
  vnoremap < <gv
  vnoremap > >gv

  " Swap two words.
  nnoremap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

  " qq to record, Q to replay.
  nnoremap Q @q

  " Quickly reload .vimrc.
  nnoremap <Leader>r :source $MYVIMRC<CR>:echo "~/.vimrc reloaded"<CR>

"=== Prose
  function! SetProseOptions()
    setlocal spell textwidth=80 softtabstop=4 tabstop=4 shiftwidth=4

    " Fix the current misspelling and jump to the next.
    nnoremap <buffer> <C-f> 1z=]s

    " Open a word in Dictionary.app.
    nnoremap <buffer> <Leader>d :silent !open dict://<cword><CR>

    " Text to Speech on the current visual selection.
    vnoremap <buffer> <Leader>s :w<Home>silent <End> !say<CR>

    " Quickly insert today's timestamp.
    iabbrev <buffer> xdate <C-r>=strftime("%m/%d/%Y %H:%M:%S (%Z)")<CR>

    " Don't count acronyms/ abbreviations as spelling errors.
    " Credit: http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/
    syntax match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell

    syntax region HtmlCommentNoSpell start="<!--" end="-->" oneline contains=@NoSpell
    highlight link HtmlCommentNoSpell Comment
  endfunction

  augroup AG_ProseOptions
    autocmd!
    autocmd Filetype {text,markdown} call SetProseOptions()
  augroup END

"=== Wild Mode (command-line completion)
  set wildmenu
  set wildmode=list:longest,list:full
  set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
  set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

"=== File Types
  augroup AG_FileTypeOptions
    autocmd!

    " Python PEP8 4 space indent
    autocmd FileType python setlocal softtabstop=4 tabstop=4 shiftwidth=4
  augroup END

"=== Misc Functions
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
  function! OpenFileInChrome()
    exec 'silent !open -a "Google Chrome" "%"'
    redraw!
  endfunction
  command! Chrome call OpenFileInChrome()

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

  function! RefreshAllBuffers()
    let currBuff = bufnr("%")
    " refresh buffers
    execute 'silent bufdo e!'
    " Go back to the original buffer.
    execute 'buffer ' . currBuff
    " bufdo e! turns syntax highlighting off for efficiency.
    syntax enable
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
  command! J call TodaysJournalEntry()

  " .vimrc
  command! Vimrc exec ':e ~/.vimrc'
  command! V Vimrc

  " todo.md
  command! Todo exec ':e ~/notes/ustasb/todo.md'
  command! T Todo

  " scratch.md
  command! Scratch exec ':e ~/notes/scratch.md'
  command! S Scratch

  augroup AG_Misc
    autocmd!

    autocmd BufReadPost * :call ResetCursorPosition()

    autocmd FileType * autocmd BufWritePre <buffer> :call StripTrailingWhitespaces()

    " Don't auto-comment the next line on Enter.
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  augroup END

"=== Plugin Settings
  " vim-javascript
  let g:javascript_ignore_javaScriptdoc = 1

  " vim-jsx
  let g:jsx_ext_required = 0

  " RSpec.vim
  augroup AG_Rspec
    autocmd!
    autocmd FileType ruby nnoremap <buffer> <Leader>s :call RunNearestSpec()<CR>
    autocmd FileType ruby nnoremap <buffer> <Leader>S :call RunCurrentSpecFile()<CR>
  augroup END

  " Vimux
  let g:rspec_command = 'call VimuxRunCommand("bundle exec rspec {spec}")'

  " NERD Tree
  let NERDTreeIgnore = ['\.o$', '.DS_Store', 'Icon']
  let NERDTreeShowHidden = 1
  let NERDTreeStatusline = ' ' " blank
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
  let g:ackprg = 'rg --hidden --vimgrep --smart-case'
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

  " vim-markdown
  let g:markdown_enable_conceal = 1
  let g:markdown_include_jekyll_support = 0
  let g:markdown_enable_folding = 0
  let g:markdown_enable_mappings = 0
  let g:markdown_enable_input_abbreviations = 0

  " Vim Markdown Preview
  let g:vim_markdown_preview_pandoc = 1
  let g:vim_markdown_preview_browser = 'Google Chrome'
  " gfm = Github Flavored Markdown
  let g:vim_markdown_preview_pandoc_args = '--from markdown+autolink_bare_uris+lists_without_preceding_blankline -f gfm --to=html5 --self-contained --highlight-style=haddock --css $HOME/dotfiles/markdown_css/github.css'
  autocmd FileType markdown nnoremap <Leader>p :call Vim_Markdown_Preview()<CR>

  " vim-markdown-toc
  let g:vmt_list_item_char = '-'
  let g:vmt_cycle_list_item_markers = 0
  " HACK: vim-markdown-toc and vim-gnupg don't play together well. Both try
  " to edit the buffer upon saving. If the encrypted content has a TOC, the
  " content will be truncated before saving. As a workaround, don't
  " automatically update the TOC if the file is encrypted.
  let g:vmt_auto_update_on_save = 0
  augroup AG_VimMarkdownToc
    autocmd!
    autocmd BufWritePre *.{md,mdown,mkd,mkdn,markdown,mdwn}
      \ if expand('%') !~ 'md\.asc$' | :silent UpdateToc
  augroup END

  " Vim Voom
  let g:voom_python_versions = [3, 2]
  let g:voom_tree_placement = 'left'
  let g:voom_tree_width = 40
  let g:voom_default_mode = 'markdown'
  autocmd FileType markdown nnoremap <buffer> <Leader>o :VoomToggle markdown<CR>

  " Tagbar
  let g:tagbar_silent = 1
  let g:tagbar_compact = 1
  let g:tagbar_iconchars = ['▸', '▾']
  nnoremap <Leader>o :TagbarToggle<CR>
  let g:tagbar_status_func = 'TagbarStatusFunc'
  function! TagbarStatusFunc(current, sort, fname, ...) abort
  	let g:lightline.fname = a:fname
  	return lightline#statusline(0)
  endfunction

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

  " vim-sneak
  let g:sneak#label = 1
  map f <Plug>Sneak_s
  map F <Plug>Sneak_S

  " ALE
  let g:ale_enabled = 0
  let g:ale_completion_enabled = 0
  let g:ale_sign_error = '✖' " ✘
  let g:ale_sign_warning = '✦' " ⚑
  nnoremap <Leader>l :ALEToggle<CR>

  " fzf.vim
  let g:fzf_command_prefix = 'Fzf'
  let g:fzf_layout = { 'up': '~50%' }
  let g:fzf_colors = {
    \ 'prompt':   ['fg', 'Global'],
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
  autocmd! User FzfStatusLine setlocal statusline=%#
  " Search through all files recursively.
  nnoremap <silent> <Leader>f :FzfFiles<CR>
  " MRU
  nnoremap <silent> <Leader>m :FzfHistory<CR>
  " Ctags
  nnoremap <silent> <Leader>t :FzfTags<CR>
  " Buffers
  nnoremap <silent> <Leader>b :FzfBuffers<CR>
  " Notes
  nnoremap <silent> <Leader>n :FzfFiles ~/notes<CR>

  " vim-startify
  let g:startify_change_to_dir = 0
  let g:startify_fortune_use_unicode = 1
  let g:startify_custom_header = 'map(startify#fortune#boxed(), "\"   \".v:val")'

  " lightline.vim
  set noshowmode " Don't show the default mode indicator.

  let g:lightline = {
  \   'colorscheme': 'gruvbox',
  \   'enable': {
  \     'tabline': 0,
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
    return &filetype == 'nerdtree' ? 'NERDTree' :
      \ &filetype == 'tagbar' ? 'Tagbar' :
      \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

  function! LightlineFilename()
    let fname = expand('%:t')
    return &filetype == 'nerdtree' ? '' :
      \ &filetype == 'tagbar' ? '' :
      \ fname != '' ? fname : '[No Name]'
  endfunction

  function! LightlineModified()
    return &modified ? "+" : ""
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
  endfunction

  function! LightlineFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
  endfunction

  function! LightlineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  endfunction

"=== Local Customizations

  if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
  endif
