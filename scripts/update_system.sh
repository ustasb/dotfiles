#!/usr/bin/env bash

# Brian-specific update script.

echo "Updating Homebrew and installed tools..."
brew update && brew upgrade && brew cleanup && brew cask cleanup

echo "Installing config files and updating Vim plugins..."
rake -f ~/dotfiles/Rakefile update

if [ ! -d ~/projects ]; then
  echo "Creating ~/projects..."
  mkdir ~/projects
fi

if [ -d $USTASB_NOTES_DIR_PATH ] && [ ! -L ~/notes ]; then
  echo "Creating ~/notes..."
  ln -s $USTASB_NOTES_DIR_PATH ~/notes
fi
