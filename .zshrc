# Brian Ustas's .zshrc

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

  # Automatically enter directories without cd
  setopt auto_cd

  # Makes keys work within tmux...
  bindkey "^P" up-line-or-search
  bindkey "^R" history-incremental-search-backward

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

  # Enable extended globbing
  setopt EXTENDED_GLOB

  # If a pattern for filename generation has no matches, print an error
  unsetopt nomatch

  # Enable colored output from `ls`
  export CLICOLOR=1

#=== ENVS

  # Use Vim as the visual editor
  export VISUAL=vim
  export EDITOR=$VISUAL

  # NPM
  export PATH=/usr/local/share/npm/bin:$PATH
  # Homebrew
  export PATH=/usr/local/bin:$PATH
  # rbenv
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - zsh)"

  # To hold zsh functions
  fpath=( "$HOME/.zfunctions" $fpath )

#=== Aliases

  alias mkdir='mkdir -p'
  alias ...='../..'
  alias c='clear'
  alias l='ls'
  alias ll='ls -alh'

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

#=== Prompt

  autoload -U promptinit && promptinit

  PURE_CMD_MAX_EXEC_TIME=10

  prompt pure
