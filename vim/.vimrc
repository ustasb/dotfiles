" Brian Ustas's .vimrc
" Last Updated: 12/03/12
" Tested with Vim v7.2.411
"
"    Enhancements
"    Color Scheme: http://ethanschoonover.com/solarized
"    JavaScript Syntax: http://www.vim.org/scripts/script.php?script_id=1491

"-- General
    filetype on             " Autodetect the file type which is useful for syntax highlighting.
    filetype plugin indent on

    set mouse=a             " Enable mouse support in the terminal for all modes.
    set backspace=2         " Enable backspace in gVim.
    set nocompatible        " Don't start Vim in vi-compatibility mode.
    set autochdir           " Automatically set the working directory to the file being edited.
    set ffs=unix,dos,mac    " File Format (Relevant to line ending type)
    set encoding=utf-8      " Character encoding

    " Disable all error bells.
    set noeb vb t_vb=
    au GUIEnter * set vb t_vb=

    " I don't need this clutter.
    set nobackup
    set nowritebackup
    set noswapfile

"-- UI
    syntax enable           " Enable syntax highlighting.
    try
        set background=dark
        colorscheme solarized
    catch
        colorscheme torte
    endtry

    " Visually define an 80 character limit.
    if exists('+colorcolumn')
        set colorcolumn=81
        highlight ColorColumn ctermbg=Black guibg=#000000
    else
        au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>81.\+', -1)
    endif

    set number              " Line numbering
    set expandtab           " Insert spaces instead of tabs.
    set shiftwidth=4        " Sets the indentation width for < and >.
    set softtabstop=4       " Make 4 spaces behave like a tab.
    set autoindent          " Copies the indentation from the previous line.
    set incsearch           " Start searching while the search string is being typed.

"-- GUI specific
    if has('gui_running')
        set guifont=Menlo:h13,Consolas:h11
        set lines=45 columns=175    " Default window size
        set guioptions-=m           " Removes menubar
        set guioptions-=T           " Removes toolbar
    endif

"-- Auto Commands
    if has('autocmd')
        " Save the code folds and cursor position automatically.
        au BufWinLeave ?* mkview
        au BufWinEnter ?* silent loadview

        " Turn off visual bells in gVim.
        autocmd GUIEnter * set visualbell t_vb=

        " Remove whitespace at the end of lines.
        fun! <SID>StripTrailingWhitespaces()
            let l = line('.')
            let c = col('.')
            %s/\s\+$//e
            call cursor(l, c)
        endfun
        autocmd FileType * autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

        " Python smart indentation.
        autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

        " Ruby two space indentation support.
        autocmd FileType ruby setlocal expandtab shiftwidth=2 softtabstop=2
    endif
