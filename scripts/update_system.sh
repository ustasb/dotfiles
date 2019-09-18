#!/usr/bin/env bash

echo "Updating Homebrew and installed tools..."
brew update && brew upgrade && brew cleanup

echo "Installing config files and updating Vim plugins..."
rake -f ~/dotfiles/Rakefile update
