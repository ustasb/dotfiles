#!/usr/bin/env bash

# Customizes the Finder sidebar favorites.
# Usage: `./main.sh`

cd ~/dotfiles/scripts/osx_finder_sidebar/

curl -O https://raw.githubusercontent.com/robperc/FinderSidebarEditor/master/FinderSidebarEditor.py

# Use Apple's Python which includes pyobjc.
/usr/bin/python customize_sidebar.py

rm FinderSidebarEditor*

echo "Done!"
