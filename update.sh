#!/usr/bin/env bash

echo "Updating Homebrew and installed tools..."
brew update && brew upgrade && brew cleanup && brew cask cleanup

echo "Installing config files and updating Vim plugins..."
rake update

if [ ! -d ~/projects ]; then
  echo "Making ~/projects..."
  mkdir ~/projects
fi

echo "Installing fzf completion scripts..."
/usr/local/opt/fzf/install --all
