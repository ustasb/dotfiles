# [Brian Ustas's](http://brianustas.com) Configuration Files

- shell: [zsh](http://www.zsh.org/)
- editor: [Neovim](https://neovim.io/)
- terminal emulator: [iTerm2](http://www.iterm2.com/)

## Usage

- Import my iTerm2 [preferences file](https://github.com/ustasb/dotfiles/blob/master/iterm2/com.googlecode.iterm2.plist).
- Clone this repo into `$HOME`.
- `rake install`
- Complete the instructions under `ENV Template` in `home/.zshrc`.
- `rake update` to update the system.

## iTerm Profiles

After switching profiles, you'll need to run either `dark_theme` or
`light_theme`.

This updates tmux colors if necessary and sets `ITERM_PROFILE` to
help Vim select the correct color scheme.

### Gruvbox Dark (default)

- shortcut: `^⌘k`
- 13pt SF Mono Light
- [Vim theme](https://github.com/ustasb/gruvbox)
- [iTerm2 theme](https://github.com/ustasb/dotfiles/blob/master/iterm2/colors/gruvbox_dark.itermcolors)

### Gruvbox Light

- shortcut: `^⌘l`
- 13pt SF Mono Regular
- [Vim theme](https://github.com/ustasb/gruvbox)
- [iTerm2 theme](https://github.com/ustasb/dotfiles/blob/master/iterm2/colors/gruvbox_light.itermcolors)
