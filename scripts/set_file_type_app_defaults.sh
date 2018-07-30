#!/usr/bin/env bash

# `brew install duti`
# To get the Bundle ID of an app: mdls -name kMDItemCFBundleIdentifier -r <app_path>
# Usage: `./set_file_type_app_defaults.sh`

duti -s org.videolan.vlc .mp4 all

# Plain text files without an extension.
duti -s org.vim.MacVim public.plain-text all
# executable scripts
duti -s org.vim.MacVim public.unix-executable all

duti -s org.vim.MacVim .txt all
duti -s org.vim.MacVim .md all
duti -s org.vim.MacVim .rb all
duti -s org.vim.MacVim .py all
duti -s org.vim.MacVim .asc all
duti -s org.vim.MacVim .key all
duti -s org.vim.MacVim .log all
duti -s org.vim.MacVim .conf all

duti -s com.google.Chrome .svg all

duti -s com.apple.Preview .pdf all
