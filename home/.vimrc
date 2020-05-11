set encoding=utf-8
scriptencoding utf-8

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

" === vim-plug === {{{

  call plug#begin('~/.vim/plugged')
    Plug 'itchyny/lightline.vim'

    " editing
    Plug 'tpope/vim-commentary', { 'on': 'Commentary' }
    Plug 'tpope/vim-surround'
    Plug 'junegunn/vim-easy-align', { 'on': 'EasyAlign' }
    Plug 'dense-analysis/ale'

    " completion
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'sirver/UltiSnips'

    " colors
    Plug 'ustasb/gruvbox'

    " git
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb' " GitHub support

    " prose
    Plug 'plasticboy/vim-markdown'
    Plug 'reedes/vim-litecorrect', { 'for': ['text', 'markdown', 'pandoc'] }
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
    Plug 'JulesWang/css.vim', { 'for': 'css' }
    Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
    Plug 'chr4/nginx.vim', { 'for' : 'nginx' }

    " ruby
    Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
    Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }

    " python
    Plug 'vim-python/python-syntax', { 'for': 'python' }
    Plug 'tmhedberg/SimpylFold', { 'for': 'python' }

    " misc
    Plug 'szw/vim-maximizer', { 'on': 'MaximizerToggle' }
    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
    Plug 'lvht/tagbar-markdown', { 'for': 'markdown' }
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTree', 'NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'jamessan/vim-gnupg'
    Plug 'tpope/vim-repeat'
    Plug 'mhinz/vim-startify'
  call plug#end()

" }}}

" === Basic === {{{

  let g:bu_spell_file = expand('$USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/settings/vim/vim-spell-en.utf-8.add')

  filetype plugin indent on
  syntax enable

  " file format (relevant to line ending type)
  " Unix based systems and Mac OS X+.
  set fileformats=unix,dos
  " English spelling
  set spelllang=en
  " Custom spellfile for `zg` and `zw`.
  execute('set spellfile="' . g:bu_spell_file . '"')
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

  " Disable text concealing.
  set conceallevel=0

  " The default is 4000 which is rather slow. coc.nvim recommends 300.
  set updatetime=300

  " Don't show Vim's welcome message.
  set shortmess=I
  " Make the save message shorter. Helps avoid the 'Hit ENTER to continue' message.
  set shortmess+=at
  " Don't show completion messages. coc.nvim recommends this.
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
    set guifont=iA\ Writer\ Mono\ S:h15
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
  let maplocalleader = "\\"

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
    " Exit the Neovim terminal via jk.
    tnoremap jk <C-\><C-n>
  endif

" }}}

" === Wild Mode (command-line completion) === {{{

  set wildmenu
  set wildmode=list:longest,list:full
  set wildignore+=*.csv,*.tsv,*.json,*.h4,*.h5,*.db
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
    if line("'\"") > 0 && line("'\"") <= line('$')
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
  command! Chrome !open -a "Google Chrome" %:p

  " Open the file's folder in Finder.
  command! Finder !open -a "Finder" %:p:h

  " Create a tags file.
  function! CreateCtagsFile()
    let cwd = getcwd()
    silent execute('silent !ctags ' . cwd)
    echom 'Created tags file at: ' . cwd . '/tags'
  endfunction
  command! Ctags call CreateCtagsFile()

  " Allow saving with sudo permission.
  function! SudoSaveFile()
    execute 'silent :w !sudo tee > /dev/null %'
  endfunction
  command! SudoSave call SudoSaveFile()

  function! RefreshAllBuffers()
    " Temporarily disable syntax highlighting to speed things up.
    syntax off
    let currBuff = bufnr('%')
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
    let interpreter = &filetype ==# 'ruby' ? 'ruby' :
      \ &filetype ==# 'python' ? 'python' :
      \ &filetype ==# 'javascript' ? 'node' :
      \ &filetype ==# 'javascript.jsx' ? 'node' :
      \ &filetype ==# 'sh' ? 'bash' : ''

    if interpreter ==# ''
      echom "No interpreter found for filetype '" . &filetype . "'!"
    else
      execute '!' . interpreter . ' %'
    endif
  endfunction
  nnoremap <Leader>e :call ExecuteFile()<CR>

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
      normal! zM
    else
      let g:folds_open = 1
      normal! zR
    endif
    " center the cursor
    normal! zz
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
    silent execute('!open ' . dash_uri)
  endfunction
  nnoremap <Leader>d :call OpenInDash()<CR>

  " Use linters to 'fix' files when possible.
  function! AutoFix()
    if &filetype ==# 'javascript.jsx'
      " For JS files, coc-eslint's executeAutofix is faster than ALE's.
      :CocCommand eslint.executeAutofix
    else
      :ALEFix
    endif
  endfunction
  command! Fix call AutoFix()

  function! PrintSyntaxGroupAtCursor()
    echo synIDattr(synID(line('.'), col('.'), 1), 'name')
  endfunction
  command! PrintSyntaxGroupAtCursor call PrintSyntaxGroupAtCursor()

  function! HighlightGroupsTest()
    so $VIMRUNTIME/syntax/hitest.vim
  endfunction
  command! HighlightGroupsTest call HighlightGroupsTest()

  command! EditSpellFile execute('e ' . g:bu_spell_file)

  " .vimrc
  command! Vimrc e ~/dotfiles/home/.vimrc
  command! V Vimrc
  command! VL e ~/.vimrc.local

  " .zshrc
  command! Zshrc e ~/dotfiles/home/.zshrc
  command! Z Zshrc
  command! ZL e ~/.zshrc.local

  " quickly quit
  command! Q qa
  nnoremap Q qa<CR>

  augroup AG_Misc
    autocmd!

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

  " NERD Tree {{{
  let g:NERDTreeIgnore = ['\.git', '.DS_Store', 'Icon', '__pycache__', '\.o$']
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeShowHidden = 1
  let g:NERDTreeAutoDeleteBuffer = 1
  let g:NERDTreeWinSize = 30
  let g:NERDTreeStatusline = -1
  let g:NERDTreeMapActivateNode = '<Space>'
  nnoremap <C-n> :NERDTreeToggle<CR>
  nnoremap <Leader>g :NERDTreeFind<CR>
  " }}}

  " Vim Fugitive {{{
  " Slows down my C-r command mode mapping.
  let g:fugitive_no_maps = 1
  " }}}

  " Vim Maximizer {{{
  nnoremap <C-W>o :MaximizerToggle<CR>
  " }}}

  " Ack.vim {{{
  let $RIPGREP_VIM_ARGS = ' --hidden --smart-case --ignore-file $HOME/.rgignore-vim'
  let g:ackprg = 'rg --vimgrep ' . $RIPGREP_VIM_ARGS
  let g:ack_lhandler = 'topleft lopen'
  let g:ack_qhandler = 'topleft copen'
  cnoreabbrev Ag Ack!
  cnoreabbrev AG Ack!
  cnoreabbrev ag Ack!
  " }}}

  " Goyo.vim {{{
  nnoremap <Leader>z :Goyo<CR>
  let g:goyo_width = 100
  let g:goyo_height = '90%'
  " }}}

  " Vim-Commentary {{{
  vnoremap <Leader>c :Commentary<CR>
  nnoremap <Leader>c :Commentary<CR>
  " }}}

  " Tagbar {{{
  let g:tagbar_width = 30
  let g:tagbar_silent = 1
  let g:tagbar_compact = 1
  let g:tagbar_autofocus = 1
  let g:tagbar_autoclose = 1
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
  let g:GPGPreferArmor = 0
  let g:GPGUseAgent = 1
  " Only signs upon creation, not after editing.
  " Turning it off - too inconsistent. Even after forking and fixing, it's too slow.
  let g:GPGPreferSign = 0
  let g:GPGUsePipes = 1
  let g:GPGFilePattern = '*.\(gpg\|asc\)'
  let g:GPGDefaultRecipients = ['Brian Ustas <brianustas@gmail.com>']
  " }}}

  " vim-startify {{{
  let g:startify_lists = [
    \ { 'type': 'files', 'header': ['  MRU'] },
    \ { 'type': 'dir', 'header': ['  MRU ' . getcwd()] },
    \ ]
    " TODO: implement
    " \ { 'type': function('s:my_recent_notes'), 'header': ['  MRU Notes'] },
  let g:startify_padding_left = 2
  let g:startify_update_oldfiles = 1
  let g:startify_fortune_use_unicode = 1
  let g:startify_custom_header = 'startify#pad(startify#fortune#boxed())'
  let g:startify_change_to_dir = 0
  let g:startify_files_number = 10
  let g:startify_enable_special = 0
  let g:startify_custom_indices = ['f', 'g', 'h']
  let g:startify_skiplist = [
    \ 'spec/fixtures/.*.yml',
    \ ]
  " highlight the line on the cursor.
  " autocmd User Startified setlocal cursorline
  command! Welcome Startify
  command! W Welcome
  " }}}

  " fzf.vim {{{
  let $FZF_DEFAULT_COMMAND = $FZF_DEFAULT_COMMAND . $RIPGREP_VIM_ARGS
  let g:fzf_command_prefix = 'Fzf'
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
  let g:fzf_preview_window = 'down:50%'
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
  " pwd files
  nnoremap <silent> <Leader>f :FzfFiles<CR>
  " MRU
  nnoremap <silent> <Leader>F :FzfHistory<CR>
  " Vim help
  nnoremap <silent> <Leader>h :FzfHelptags<CR>
  " buffers
  nnoremap <silent> <Leader>b :FzfBuffers<CR>
  " ctags
  nnoremap <silent> <Leader>t :FzfTags<CR>
  " search history
  nnoremap <silent> q/ :FzfHistory/<CR>
  " command history
  nnoremap <silent> q: :FzfHistory:<CR>
  " }}}

  " ALE (Used for the :Fix command and linting what coc.nvim can't.) {{{
  let g:ale_enabled = 1
  let g:ale_history_enabled = 0
  let g:ale_history_log_output = 0
  let g:ale_completion_enabled = 0

  let g:ale_sign_error = 'E'
  let g:ale_sign_warning = 'W'
  let g:ale_sign_info = 'I'

  let g:ale_linters_explicit = 1
  let g:ale_linters = {
    \  'css': ['stylelint'],
    \  'scss': ['stylelint'],
    \  'vim': ['vint'],
    \ }

  let g:ale_fix_on_save = 0
  let g:ale_fixers = {
    \ 'ruby': ['rubocop'],
    \ 'javascript': ['eslint'],
    \ 'css': ['stylelint'],
    \ 'scss': ['stylelint'],
    \ }
  " }}}

  " coc.nvim (Conquer of Completion) {{{
  " . : current buffer
  " w : buffers from other windows
  " b : buffers from buffer list
  set complete=.,w,b
  set completeopt=menu,menuone,noselect

  let g:coc_status_error_sign = 'E:'
  let g:coc_status_warning_sign = 'W:'
  let g:coc_status_info_sign = 'I:'
  let g:coc_start_at_startup = 1
  let g:coc_enable_locationlist = 1  " needed for <Plug>(coc-references)
  let g:coc_global_extensions = [
    \ 'coc-git',
    \ 'coc-css',
    \ 'coc-json',
    \ 'coc-yaml',
    \ 'coc-html',
    \ 'coc-dictionary',
    \ 'coc-tag',
    \ 'coc-ultisnips',
    \ 'coc-python',
    \ 'coc-solargraph',
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-tailwindcss',
    \ 'coc-pairs',
    \ 'coc-highlight',
    \ 'coc-vimlsp',
    \ ]

  " Use <Tab> and <S-Tab> for triggering and navigating the completion list.
  function! s:CocTab()
    if pumvisible()
      return "\<C-n>"
    elseif <SID>check_back_space()
      return "\<TAB>"
    elseif get(b:, 'coc_suggest_disable', 0)
      if get(b:, 'coc_suggest_disable_use_dict', 0)
        " dictionary completion
        return "\<C-x>\<C-k>\<C-n>"
      else
        return "\<TAB>"
      endif
    else
      return coc#refresh()
    endif
  endfunction
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
  endfunction
  inoremap <silent><expr> <TAB> <SID>CocTab()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Jump to definition of current symbol.
  nmap <silent> gd <Plug>(coc-definition)
  " Jump to references of current symbol.
  nmap <silent> gr <Plug>(coc-references)
  command! -nargs=0 Rename call CocAction('rename')

  " Use [c and ]c for navigating diagnostics.
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Show documentation for the current word.
  function! s:showDocumentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  nnoremap <silent> K :call <SID>showDocumentation()<CR>
  " }}}

  " python-syntax {{{
  let g:python_highlight_all = 1
  let g:python_highlight_space_errors = 0
  let g:python_highlight_indent_errors = 0
  " }}}

  " vim-markdown {{{
  let g:vim_markdown_no_default_key_mappings = 1
  let g:vim_markdown_strikethrough = 1
  let g:vim_markdown_emphasis_multiline = 1
  let g:vim_markdown_autowrite = 0
  let g:vim_markdown_edit_url_in = 'current'
  let g:vim_markdown_no_extensions_in_markdown = 0
  " this is annoying
  let g:vim_markdown_new_list_item_indent = 0
  " and this
  let g:vim_markdown_auto_insert_bullets = 0

  let g:vim_markdown_conceal = 0
  let g:vim_markdown_conceal_code_blocks = 0
  let g:tex_conceal = '' " disables Latex concealing

  let g:vim_markdown_math = 1
  let g:vim_markdown_frontmatter = 1 " jekyll
  let g:vim_markdown_toml_frontmatter = 0 " hugo
  let g:vim_markdown_json_frontmatter = 0 " hugo
  " }}}

  " UltiSnips {{{
  let g:UltiSnipsExpandTrigger = '<C-Space>'
  let g:UltiSnipsJumpForwardTrigger = '<C-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
  let g:UltiSnipsListSnippets = '<Nop>' " use FzfSnippets
  let g:UltiSnipsSnippetDirectories = [$HOME . '/dotfiles/vim/ultisnips']
  command! Ulti UltiSnipsEdit
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
  \       ['cocstatus', 'fileformat', 'fileencoding', 'filetype']
  \     ]
  \   },
  \   'component_function': {
  \     'mode': 'LightlineMode',
  \     'filename': 'LightlineFilename',
  \     'modified': 'LightlineModified',
  \     'fileformat': 'LightlineFileformat',
  \     'fileencoding': 'LightlineFileencoding',
  \     'filetype': 'LightlineFiletype',
  \     'cocstatus': 'coc#status'
  \   },
  \   'subseparator': {
  \     'left': '│',
  \     'right': '│'
  \   }
  \ }

  function! LightlineMode()
    let fname = expand('%:t')
    return &filetype ==# 'nerdtree' ? '' :
      \ &filetype ==# 'tagbar' ? '' :
      \ &filetype ==# 'qf' ? '' :
      \ &filetype ==# 'fzf' ? '' :
      \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

  function! LightlineFilename()
    let fname = expand('%:t')
    return &filetype ==# 'nerdtree' ? 'NERDTree' :
      \ &filetype ==# 'tagbar' ? 'Tagbar' :
      \ &filetype ==# 'qf' ? 'QuickFix' :
      \ &filetype ==# 'fzf' ? 'fzf' :
      \ fname !=# '' ? fname : '[No Name]'
  endfunction

  function! LightlineModified()
    return &modified ? '+' : ''
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > 80 ? &fileformat : ''
  endfunction

  function! LightlineFileencoding()
    return winwidth(0) > 80 ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
  endfunction

  function! LightlineFiletype()
    return winwidth(0) > 80 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  endfunction
  " }}}

" }}}

" === Prose === {{{

  function! SetProseOptions()
    " Fix common typos.
    call litecorrect#init()

    " Disable COC's autocompletion—it's too noisy while writing.
    let b:coc_suggest_disable = 1
    " Dictionary completion when <Tab> is pressed.
    let b:coc_suggest_disable_use_dict = 1

    " For dictionary completion with coc.nvim.
    setlocal dictionary=$HOME/dotfiles/vim/en_popular.txt

    setlocal textwidth=70
    setlocal spell softtabstop=4 tabstop=4 shiftwidth=4

    " Ignore vim-markdown's indentexpr
    setlocal indentexpr=""
    " Format list bullets like Vim formats comments.
    setlocal comments=fb:*,fb:-,fb:+,n:>
    " quote syntax
    setlocal commentstring=>\ %s

    " docs: Where it makes sense, remove a comment leader when joining lines
    setlocal formatoptions=j
    " docs: Automatic formatting for text and comments
    setlocal formatoptions+=tc
    " docs: Allow formatting of comments with "gq"
    setlocal formatoptions+=q
    " docs: Long lines are not broken in insert mode
    setlocal formatoptions+=l
    " docs: When formatting text, recognize numbered lists (doesn't work well with 2)
    setlocal formatoptions+=n
    " docs: Don't break lines at single spaces that follow periods.
    setlocal formatoptions+=p
    " " disable: Automatically insert the current comment leader
    " setlocal formatoptions-=r
    " " disable: Automatically insert the current comment leader after hitting
    " setlocal formatoptions-=o

    " improved gq formatting (credit: https://github.com/jparise/dotfiles/blob/90a2a6baa01b92f11d9673ecd8176f3bc9aaa36e/vim/after/ftplugin/text.vim#L6-L17)
    setlocal formatlistpat=^\\s*                    " Optional leading whitespace
    setlocal formatlistpat+=[                       " Start class
    setlocal formatlistpat+=\\[({]\\?               " |  Optionally match opening punctuation
    setlocal formatlistpat+=\\(                     " |  Start group
    setlocal formatlistpat+=[0-9]\\+                " |  |  A number
    setlocal formatlistpat+=\\\|[iIvVxXlLcCdDmM]\\+ " |  |  Roman numerals
    setlocal formatlistpat+=\\\|[a-zA-Z]            " |  |  A single letter
    setlocal formatlistpat+=\\)                     " |  End group
    setlocal formatlistpat+=[\\]:.)}                " |  Closing punctuation
    setlocal formatlistpat+=]                       " End class
    setlocal formatlistpat+=\\s\\+                  " One or more spaces
    setlocal formatlistpat+=\\\|^\\s*[-–+o*]\\s\\+  " Or ASCII style bullet points

    " visual tweaks
    highlight link mkdListItem GruvboxGreenBold
    highlight link mkdLink markdownUrl
    highlight link mkdInlineUrl markdownUrl
    highlight link mkdHeading GruvboxBlue
    highlight link htmlH1 GruvboxGreenBold
    highlight link htmlH2 GruvboxGreenBold
    highlight link htmlH3 GruvboxGreenBold
    highlight link htmlH4 GruvboxGreenBold
    highlight link htmlH5 GruvboxGreenBold
    highlight link htmlH6 GruvboxGreenBold

    " Fix the previous misspelling.
    nnoremap <buffer> <C-f> [s1z=<C-o>
    inoremap <buffer> <C-f> <C-g>u<Esc>[s1z=`]A<C-g>u

    " Open a word in Dictionary.app.
    nnoremap <buffer> <Leader>d :silent !open dict://<cword><CR>

    " Surround cursor word with backticks indicating code.
    " create mark x, add backticks, go back to mark x, move right one char
    nnoremap <buffer> <Leader>C :normal mxysiW``xl<CR>

    " Preface each line with '- ' for quickly creating lists.
    vnoremap <buffer> <Leader>l :s/^\(\s*\)/\1- /<CR>

    " Text to Speech on the current visual selection.
    vnoremap <buffer> <Leader>s :w<Home>silent <End> !say<CR>

    " TODO: remove this
    " Adds periods and capitalization.
    " create mark x, select line, professionalize, go back to mark x
    nnoremap <buffer> <Leader>t :execute('normal mxV,t`x')<CR>
    vnoremap <buffer> <Leader>t :!ruby ~/dotfiles/scripts/professionalize_text.rb<CR>
  endfunction

  augroup AG_ProseOptions
    autocmd!
    autocmd Filetype {text,markdown,pandoc} call SetProseOptions()
  augroup END

" }}}

" === Local Customizations === {{{

  if filereadable(glob('~/.vimrc.local'))
    source ~/.vimrc.local
  endif

" }}}
