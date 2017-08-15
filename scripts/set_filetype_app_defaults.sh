#!/usr/bin/env bash

# brew install duti
# To get the Bundle ID of an app: mdls -name kMDItemCFBundleIdentifier -r <app_path>

duti -s org.videolan.vlc .mp4 all
duti -s org.vim.MacVim .txt all
duti -s org.vim.MacVim .md all
duti -s org.vim.MacVim .rb all
duti -s org.vim.MacVim .asc all
duti -s org.vim.MacVim .key all
duti -s org.vim.MacVim .log all
