#!/usr/bin/env bash

# Customizes the Finder sidebar favorites.
# e.g.: `./main.sh`

curl -O https://raw.githubusercontent.com/robperc/FinderSidebarEditor/master/FinderSidebarEditor.py

python customize_sidebar.py

rm FinderSidebarEditor*

echo "Done!"
