# Brian Ustas's .zshrc

#=== zsh Options

  # Completion
  autoload -U compinit
  compinit

  # Automatically enter directories without cd
  setopt auto_cd

  # Use vim as the visual editor
  export VISUAL=vim
  export EDITOR=$VISUAL

  # vi prompt mode
  bindkey -v
  bindkey jk vi-cmd-mode

  # Add some readline keys back
  bindkey "^A" beginning-of-line
  bindkey "^E" end-of-line
  bindkey "^P" history-search-backward

  # Use incremental search
  bindkey "^R" history-incremental-search-backward

  # Ignore duplicate history entries
  setopt histignoredups

  # Keep lots of history
  export HISTSIZE=4096

  # No beeping
  unsetopt beep

  # Automatically pushd
  setopt auto_pushd
  export dirstacksize=5

  # awesome cd movements from zshkit
  #setopt AUTOCD
  #setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
  #setopt cdablevars

  # Try to correct command line spelling
  setopt CORRECT CORRECT_ALL

  # Enable extended globbing
  setopt EXTENDED_GLOB

  # If a pattern for filename generation has no matches, print an error
  unsetopt nomatch

  # Enable colored output from ls
  export CLICOLOR=1

#=== Prompt

  # Enable color constants
  autoload -U colors
  colors

  # Expand functions in the prompt
  setopt prompt_subst

  PROMPT='$(git_prompt_info)[${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%~%{$reset_color%}] '

#=== ENVS

  # NPM
  export PATH=/usr/local/share/npm/bin:$PATH
  # Homebrew
  export PATH=/usr/local/bin:$PATH
  # rbenv
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - zsh)"

#=== Aliases

  alias mkdir='mkdir -p'
  alias ...='../..'
  alias l='ls'
  alias ll='ls -alh'

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

  # Echos the current branch name in green
  # Credit: thoughtbot
  git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ -n $ref ]]; then
      echo "[%{$fg_bold[green]%}${ref#refs/heads/}%{$reset_color%}]"
    fi
  }
