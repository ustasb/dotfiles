# Brian Ustas's .zshrc
#
# Supports OS X and Linux (tested with Yosemite and Ubuntu 14.04).
#
### Expected Installs
#
# General:
# - Vim
# - Git
# - GCC 4.8 Compiler
# - rbenv and a Ruby version (https://github.com/sstephenson/rbenv)
# - nvm and a Node.js version (https://github.com/creationix/nvm)
# - npm (https://www.npmjs.com/)
# - Pure Prompt (https://github.com/sindresorhus/pure)
# - fzf (https://github.com/junegunn/fzf)
#
# Mac Specific:
# - Homebrew
# - Boot2Docker

#== Detect OS

  platform='unknown'
  unamestr=$(uname)
  if [[ "$unamestr" == 'Darwin' ]]; then
     platform='mac'
  elif [[ "$unamestr" == 'Linux' ]]; then
     platform='linux'
  fi

#=== zsh Settings

  # Completion
  autoload -U compinit
  compinit

  # Use Emacs as the command line editor. Makes some keys work within tmux...
  bindkey -e

  # Keep lots of history
  export HISTSIZE=1000
  export SAVEHIST=1000
  export HISTFILE=~/.history

  # Share history between terminals
  setopt inc_append_history
  setopt share_history
  setopt hist_ignore_all_dups

  # No beeping
  unsetopt beep

  # Automatically pushd
  setopt auto_pushd
  export dirstacksize=5

  # Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation
  setopt EXTENDED_GLOB

  # If a pattern for filename generation has no matches, print an error
  unsetopt nomatch

  # Enable colored output from `ls`
  export CLICOLOR=1

#=== Environment Variables

  # If true, Vim and tmux will use their light themes. Defaults to a dark theme.
  # export USING_LIGHT_THEME=true

  # Use Vim as the visual editor
  export VISUAL=vim
  export EDITOR=$VISUAL

  # Homebrew
  if [[ $platform == 'mac' ]]; then
    export PATH=/usr/local/bin:$PATH
  fi

  # rbenv
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - zsh)"

  # nvm
  export NVM_DIR=~/.nvm
  if [[ $platform == 'mac' ]]; then
    source $(brew --prefix nvm)/nvm.sh
  else
    source ~/.nvm/nvm.sh
  fi

  # npm
  export PATH=/usr/local/share/npm/bin:$PATH

  # To hold zsh functions
  fpath=("$HOME/.zfunctions" $fpath)

  # Boot2Docker
  if [[ $platform == 'mac' ]]; then
    $(boot2docker shellinit 2>/dev/null)
  fi

  # fzf
  export FZF_DEFAULT_OPTS='--reverse'
  export FZF_DEFAULT_COMMAND='ag -l -g ""'  # Respects .gitignore
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh  # Allow fzf to replace Ctrl-R, etc.

#=== Aliases

  alias ...='../..'
  alias c='clear'
  alias l='ls'
  alias ll='ls -alh'
  alias cdd='cd ~/Desktop'

  # GCC 4.8 Compiler
  if ! type "$g++-4.8" > /dev/null; then
    alias g++="g++-4.8 -std=c++11"
  fi

  # Vim aliases
  if [[ $platform == 'mac' ]]; then
    MY_VIM='mvim -v' # terminal MacVim
    alias sysvim='/usr/bin/vim'
    alias vim=$MY_VIM
  elif [[ $platform == 'linux' ]]; then
    MY_VIM='vim'
  fi
  alias vi=$MY_VIM
  alias v=$MY_VIM

  # Bundler
  alias be='bundle exec'

#=== Functions

  # No arguments: `git status`
  # With arguments: acts like `git`
  # Credit: thoughtbot
  g() {
    if [[ $# > 0 ]]; then
      git $@
    else
      git status
    fi
  }
  compdef g=git  # Complete g like git

  # Create a new named tmux session with my preferred layout
  tnew() { tmux new-session -s $1 \; \
                split-window -v -p 30 \; \
                split-window -h -p 66 \; \
                split-window -h -p 50 \; \
                select-pane -t 0 }

#=== Prompt

  autoload -U promptinit && promptinit

  prompt pure
