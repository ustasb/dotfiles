# Brian Ustas's .zshrc
#
# Tested on OS X.
#
# Expected installs:
# - Homebrew (https://brew.sh)
# - Neovim (https://neovim.io)
# - Git
# - chruby and a Ruby version (https://github.com/postmodern/chruby)
# - Python 2
# - n and a Node.js version (https://github.com/tj/n)
# - Pure Prompt (https://github.com/sindresorhus/pure)
# - fzf (https://github.com/junegunn/fzf)
# - z ( https://github.com/rupa/z)
# - gpg2 (https://www.gnupg.org)
# - rg (https://github.com/BurntSushi/ripgrep)

#=== zsh Settings
  # completion
  autoload -U compinit
  compinit

  # Use Emacs as the command line editor.
  # Makes some keys work within tmux.
  bindkey -e

  # Keep lots of history.
  export HISTFILE=~/.zsh_history
  export HISTSIZE=1000
  export SAVEHIST=1000

  setopt inc_append_history
  setopt hist_find_no_dups
  setopt hist_ignore_all_dups
  # Share history between terminals.
  setopt share_history
  # Don't record an entry starting with a space.
  setopt hist_ignore_space

  # Automatically cd into directories.
  setopt autocd

  # no beeping
  unsetopt beep

  # Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation.
  setopt EXTENDED_GLOB

  # If a pattern for filename generation has no matches, print an error.
  unsetopt nomatch

  # Enable colored output from `ls`.
  export CLICOLOR=1

#=== Environment Variables
  # Ripgrep
  export RIPGREP_ARGS="--no-ignore-vcs --hidden --follow --ignore-file $HOME/.rgignore"

  # Use Neovim as the default editor.
  export BU_EDITOR="nvim"
  export VISUAL=$BU_EDITOR
  export EDITOR=$BU_EDITOR

  # chruby
  source '/usr/local/share/chruby/chruby.sh'
  source '/usr/local/share/chruby/auto.sh'

  # zsh functions
  fpath=("$HOME/.zfunctions" $fpath)

  # z
  source /usr/local/etc/profile.d/z.sh

  # fzf
  export FZF_DEFAULT_OPTS='--reverse'
  export FZF_DEFAULT_COMMAND="rg $RIPGREP_ARGS --files --no-messages"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh  # Allow fzf to replace Ctrl-R, etc.

#=== Aliases
  alias ...='../..'
  alias c='clear'
  alias ll='ls -alh'
  alias cdd='cd ~/Desktop'
  alias tmuxk='tmux kill-server'
  alias gitx='gitup'

  # Vim aliases
  alias sysvim='/usr/bin/vim'
  alias vim=$BU_EDITOR
  alias vi=$BU_EDITOR
  alias v=$BU_EDITOR

  # Preserves aliases while using sudo.
  # https://askubuntu.com/a/22043
  alias sudo='sudo '

  # Ripgrep
  alias rg="rg $RIPGREP_ARGS"
  alias ag=rg

  # Homebrew's Python 2
  # http://docs.python-guide.org/en/latest/starting/install/osx/
  if type python2 > /dev/null; then
    alias python='python2'
  fi
  if type pip2 > /dev/null; then
    alias pip='pip2'
  fi

  # GPG
  # As of 11/08/17, Homebrew's gpg is version 2.x by default.
  if type gpg2 > /dev/null; then
    alias gpg='gpg2'
  fi
  alias bu_encrypt="gpg --encrypt --sign --local-user brianustas@gmail.com --recipient brianustas@gmail.com"
  alias bu_decrypt="gpg --decrypt --local-user brianustas@gmail.com"

#=== Functions
  # no arguments: `git status`
  # with arguments: acts like `git`
  # credit: thoughtbot
  g() {
    if [[ $# > 0 ]]; then
      git $@
    else
      git status -s
    fi
  }
  compdef g=git  # Complete `g` like `git`

  # Create a new named tmux session.
  # Without arguments, the session name is the basename of the current directory.
  tnew() { tmux new-session -s ${1:-$(basename $(pwd))} }

  # Checkout a Git branch with fzf.
  fbr() {
    local branches branch
    branches=$(git branch) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | sed "s/.* //")
  }

  todo() { cd ~/notes && vim -c NERDTreeToggle -c 'wincmd l' -c T }
  alias t=todo

  # Changes the iTerm profile.
  it2_profile() {
    if [ -n "$TMUX" ]; then
      # Inspired by: https://github.com/sjl/vitality.vim/blob/4bb8c078c3a9a23f8af5db1dd95832faa802a1a9/doc/vitality.txt#L199
      echo "\033Ptmux;\033\033]50;SetProfile=$1\007\033\\"
    else
      echo "\033]50;SetProfile=$1\a"
    fi
  }

  dark_theme() {
    export ITERM_PROFILE=GruvboxDark
    if [ -n "$TMUX" ]; then
      tmux set-environment ITERM_PROFILE $ITERM_PROFILE
      tmux source-file ~/dotfiles/tmux/gruvbox_dark_theme.conf
    fi
    it2_profile $ITERM_PROFILE
  }

  light_theme() {
    export ITERM_PROFILE=GruvboxLight
    if [ -n "$TMUX" ]; then
      tmux set-environment ITERM_PROFILE $ITERM_PROFILE
      tmux source-file ~/dotfiles/tmux/gruvbox_light_theme.conf
    fi
    it2_profile $ITERM_PROFILE
  }

  # Enable access to my personal scripts.
  # Helper functions are prefixed with `bu_`.
  source ~/dotfiles/scripts/shell_functions.sh

#=== Prompt
  export PURE_GIT_PULL=0
  autoload -U promptinit && promptinit
  prompt pure

#=== GPG + SSH
  start_gpg_agent() {
    # Launch gpg-agent
    gpg-connect-agent /bye

    export GPG_TTY=$(tty)

    # Point the SSH_AUTH_SOCK to the one handled by gpg-agent.
    if [ -S $(gpgconf --list-dirs agent-ssh-socket) ]; then
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    else
      echo "$(gpgconf --list-dirs agent-ssh-socket) doesn't exist. Is gpg-agent running?"
    fi
  }

  restart_gpg_agent() {
    gpgconf --kill gpg-agent
    start_gpg_agent
  }

  start_gpg_agent

#=== Hacks

  preexec() {
    # workaround: https://github.com/Yubico/yubico-piv-tool/issues/88
    # On OSX, after sleeping or being locked, GPG operations with YubiKey will
    # throw `signing failed: agent refused operation`. This hack detects that
    # error during *some* commands and restarts the agent if necessary.
    if [[ $1 =~ "^(g|git) (publish|pull|push|fetch)" ]] || [[ $1 =~ '^ssh ' ]]; then
      ssh -T git@github.com &>/dev/null

      # Did that command fail?
      if [ $? -ne 1 ]; then
        echo "Restarting gpg-agent..."
        restart_gpg_agent &>/dev/null
      fi
    fi

    # If in a tmux pane, ensure that the local session has the correct
    # ITERM_PROFILE value. `light_theme` and `dark_theme` will set the
    # variable for the global tmux environment (which this hack reads from).
    if [ -n "$TMUX" ]; then
      export $(tmux show-environment | grep "^ITERM_PROFILE")
    fi
  }

#=== ENV Template
  # Add these to your ~/.zshrc.local

  # export USTASB_AWS_ACCESS_KEY_ID=
  # export USTASB_AWS_SECRET_ACCESS_KEY=
  # export USTASB_AWS_REGION=

  # For `bu_symlink_cryptomator` and `bu_back_up_gdrive`
  # export USTASB_CRYPTOMATOR_MOUNTED_DRIVE_NAME=
  # export USTASB_S3_BACKUP_BUCKET_NAME=
  # export USTASB_CLOUD_DIR_PATH=
  # export USTASB_SHARED_DIR_PATH=
  # export USTASB_ENCRYPTED_DIR_PATH=
  # export USTASB_UNENCRYPTED_DIR_PATH=
  # export USTASB_NOTES_DIR_PATH=

#=== Local Customizations
  [ -f ~/.zshrc.local ] && source ~/.zshrc.local

#=== Default tmux session
  # If the ustasb session doesn't exist, create it. Otherwise, attach to it.
  # Prefer tmux windows over iTerm tabs and windows.
  # I've told iTerm to ignore Command-T and Command-N.
  if [ -z "$TMUX" ] && [ $TERM_PROGRAM == 'iTerm.app' ]; then
    # -d to detach other clients.
    tmux attach -d -t ustasb 2>/dev/null || cd ~ && tnew ustasb
  fi
