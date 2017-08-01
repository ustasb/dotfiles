#!/usr/bin/env bash

brew update && brew upgrade && brew cleanup && brew cask cleanup && rake update

/usr/local/opt/fzf/install --all
