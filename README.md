# Brian Ustas's Configuration Files

* Editor: Terminal [MacVim](https://code.google.com/p/macvim/)
* Terminal Emulator: [iTerm2](http://www.iterm2.com/)

## Installing

I clone this repo into my `$HOME` directory.

See `rake -T` for options. You probably want to run `rake install` first.

Any matching dotfile in `$HOME` suffixed with `.local` will be appended to any newly
installed dotfile. For example, `.vimrc.local` will be appended to a newly
installed `.vimrc`.

For MacVim + Zsh, see [this](https://github.com/b4winckler/macvim/wiki/Troubleshooting#for-zsh-users).

## iTerm Color Profiles

First import my iTerm2 preferences [file](https://github.com/ustasb/dotfiles/blob/master/iterm2/com.googlecode.iterm2.plist).

### Light Theme - 'Pencil Light'

* Font: [Courier Prime Code](https://quoteunquoteapps.com/courierprime/)
* [Vim theme](https://github.com/reedes/vim-colors-pencil)
* [iTerm2 theme](https://github.com/mattly/iterm-colors-pencil)

### Dark Theme - 'Tomorrow Night'

* Font: [Source Code Pro](https://github.com/adobe-fonts/source-code-pro)
* [Vim theme](https://github.com/ChrisKempson/Tomorrow-Theme)
* [iTerm2 theme](https://github.com/chriskempson/base16-iterm2/blob/master/base16-tomorrow.dark.itermcolors)

## Vim Markdown Preview

`Ctrl-p` in Vim will render the Markdown doc into a self contained HTML doc. Make sure to do the following...

Update the relevant line in:

    ~/.vim/plugged/vim-markdown-preview/plugin/vim-markdown-preview.vim`

Dark theme:

    call system('pandoc --smart --to=html5 --self-contained --highlight-style=haddock --css /Users/ustasb/dotfiles/markdown_css/github.css "' . b:curr_file . '" > /tmp/vim-markdown-preview.html')

Light theme:

    call system('pandoc --smart --to=html5 --self-contained --highlight-style=haddock --css /Users/ustasb/dotfiles/markdown_css/tufte.css "' . b:curr_file . '" > /tmp/vim-markdown-preview.html')
