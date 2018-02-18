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

if [ -d $USTASB_DOCS_DIR_PATH ]; then
  BU_DOCS_SYMLINK=$HOME/bu_$(basename $USTASB_DOCS_DIR_PATH)
  echo "Creating $BU_DOCS_SYMLINK"
  ln -sfn $USTASB_DOCS_DIR_PATH $BU_DOCS_SYMLINK
fi
