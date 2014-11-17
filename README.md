# Brian Ustas's Dot/Configuration Files

* Font: [Source Code Pro Light](https://github.com/adobe/source-code-pro)
* Theme: [Tomorrow-Night](https://github.com/ChrisKempson/Tomorrow-Theme)
  - [iTerm2 theme](https://github.com/chriskempson/base16-iterm2/blob/master/base16-tomorrow.dark.itermcolors)
  - [Xcode theme](https://github.com/joedynamite/base16-xcode4/blob/master/base16-tomorrow.dark.dvtcolortheme)
* Editor: Terminal [MacVim](https://code.google.com/p/macvim/)
* Terminal: [iTerm2](http://www.iterm2.com/)
* Markdown Preview: [Markdown Preview](https://github.com/borismus/markdown-preview) (Chrome Extension)

## Installing

See `rake -T` for options.

## Ubuntu Server Setup

Log into the server and execute:

    curl https://raw.githubusercontent.com/ustasb/dotfiles/master/root_ubuntu_server_setup.sh | bash

Then log into the user (the `-` creates a new environment with the user's
settings):

    su - ustasb

Then execute:

    curl https://raw.githubusercontent.com/ustasb/dotfiles/master/user_ubuntu_server_setup.sh | bash
