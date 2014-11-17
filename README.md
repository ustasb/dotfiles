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

*Tested with Ubuntu 14.04 x64 and 14.10 x64*

Log into the server as root and execute ([Don't Pipe to your Shell](http://blog.seancassidy.me/dont-pipe-to-your-shell.html)):

    curl -O https://raw.githubusercontent.com/ustasb/dotfiles/master/ubuntu_server_setup.sh; \
    bash ubuntu_server_setup.sh; \
    rm ubuntu_server_setup.sh;

Do **not** execute the script twice!

After, log into the server as the newly created user.
