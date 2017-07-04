#!/bin/bash

brew update && brew upgrade && brew cleanup && brew cask cleanup && rake update
