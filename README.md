# Brian Ustas's Dot/Configuration Files

* Font: [Source Code Pro Light](https://github.com/adobe-fonts/source-code-pro)
* Theme: [Tomorrow Night](https://github.com/ChrisKempson/Tomorrow-Theme)
  - [iTerm2 theme](https://github.com/chriskempson/base16-iterm2/blob/master/base16-tomorrow.dark.itermcolors)
  - [Xcode theme](https://github.com/joedynamite/base16-xcode4/blob/master/base16-tomorrow.dark.dvtcolortheme)
      - Install to `~/Library/Developer/Xcode/UserData/FontAndColorThemes/`
* Editor: Terminal [MacVim](https://code.google.com/p/macvim/)
* Terminal: [iTerm2](http://www.iterm2.com/)
* Markdown Preview: [Markdown Preview](https://github.com/borismus/markdown-preview) (Chrome Extension)

## Installing

I clone this repo into my `$HOME` directory.

See `rake -T` for options. You probably want to run `rake install` first.

Any matching dotfile in `$HOME` suffixed with `.local` will be appended to any newly
installed dotfile. For example, `.vimrc.local` will be appended to a newly
installed `.vimrc`.

## Color Themes

The default color theme is the dark theme, Tomorrow Night. I sometimes need a
light theme in bright environments so I've added support for Solarized Light.
Themes affect iTerm2, Vim and tmux. To change themes:

1. Change the iTerm2 color profile and make the selected the default. The two
   options are:
- Tomorrow Night Theme
- Solarized Light Theme
2. In the `~/dotfiles` directory, run:
- `rake update` for the dark theme
- `rake update_light` for the light theme
3. Restart tmux and iTerm2. When iTerm2 complains about
   'Preference Changes Will be Lost!' just click 'Copy'.

## Ubuntu Server Setup

*Tested with Ubuntu 14.04 x64 and 14.10 x64*

Log into the server as root and execute ([Don't Pipe to your Shell](http://blog.seancassidy.me/dont-pipe-to-your-shell.html)):

    curl -O https://raw.githubusercontent.com/ustasb/dotfiles/master/ubuntu_server_setup.sh; \
    bash ubuntu_server_setup.sh; \
    rm ubuntu_server_setup.sh;

Do **not** execute the script twice!

After, log into the server as the newly created user.
