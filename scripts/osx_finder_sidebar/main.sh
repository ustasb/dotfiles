#!/usr/bin/env bash

# Customizes the Finder sidebar favorites.
# Usage: `./main.sh`

cd ~/dotfiles/scripts/osx_finder_sidebar/

curl -O https://raw.githubusercontent.com/robperc/FinderSidebarEditor/master/FinderSidebarEditor.py

python customize_sidebar.py

rm FinderSidebarEditor*

echo "Done!"
