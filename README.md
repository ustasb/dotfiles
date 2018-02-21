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

Use the zsh functions `dark_theme` and `light_theme` to change color profiles.

### Gruvbox Dark

- 13pt SF Mono Light
- [Vim theme](https://github.com/ustasb/gruvbox)
- [iTerm2 theme](https://github.com/ustasb/dotfiles/blob/master/iterm2/colors/bu_gruvbox_dark.itermcolors)

### Gruvbox Light (default)

- 13pt SF Mono Regular
- [Vim theme](https://github.com/ustasb/gruvbox)
- [iTerm2 theme](https://github.com/ustasb/dotfiles/blob/master/iterm2/colors/bu_gruvbox_light.itermcolors)
