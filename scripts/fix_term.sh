#!/bin/sh

# Define terminal capabilities
# Copied from: https://gist.github.com/joshuarli/247018f8617e6715e1e0b5fd2d39bb6c
# Confirm that your terminal is configured correctly with:
# echo `tput sitm`italics`tput ritm` `tput smso`standout`tput rmso`

brew install ncurses
/usr/local/opt/ncurses/bin/infocmp tmux-256color > ~/tmux-256color.info
sudo tic -xe tmux-256color ~/tmux-256color.info
