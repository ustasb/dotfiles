# Brian Ustas's .zshrc
#
# Tested on OS X.
#
# Expected installs:
# - Homebrew (https://brew.sh)
# - Neovim (https://neovim.io)
# - Git
# - chruby and a Ruby version (https://github.com/postmodern/chruby)
# - Conda via Anaconda (https://conda.io/docs/user-guide/install)
# - n and a Node.js version (https://github.com/tj/n)
# - Pure Prompt (https://github.com/sindresorhus/pure)
# - fzf (https://github.com/junegunn/fzf)
# - z ( https://github.com/rupa/z)
# - gpg2 (https://www.gnupg.org)
# - rg (https://github.com/BurntSushi/ripgrep)

# === zsh Settings === {{{

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

# }}}

# === Prompt === {{{

  fpath=("$HOME/.pure_prompt" $fpath) # dependencies
  export PURE_GIT_PULL=0
  autoload -U promptinit && promptinit
  prompt pure

# }}}

# === Environment Variables === {{{

  # Ripgrep
  export RIPGREP_ARGS="--no-ignore-vcs --hidden --follow --ignore-file $HOME/.rgignore"

  # Use Neovim as the default editor.
  export BU_EDITOR="nvim"
  export VISUAL=$BU_EDITOR
  export EDITOR=$BU_EDITOR

  # chruby
  source '/usr/local/share/chruby/chruby.sh'
  source '/usr/local/share/chruby/auto.sh'

  # Conda via Anaconda
  export PATH=/usr/local/anaconda3/bin:"$PATH"

# }}}

# === ustasb ENV Template === {{{

  # Add these to ~/.ustasbenv

  # export USTASB_AWS_ACCESS_KEY_ID=
  # export USTASB_AWS_SECRET_ACCESS_KEY=
  # export USTASB_AWS_REGION=

  # `bu_back_up_gdrive`
  # export USTASB_S3_BACKUP_BUCKET_NAME=
  # export USTASB_CLOUD_DIR_PATH=
  # export USTASB_SHARED_DIR_PATH=
  # export USTASB_ENCRYPTED_DIR_PATH=
  # export USTASB_UNENCRYPTED_DIR_PATH=
  # export USTASB_DOCS_DIR_PATH=
  # export USTASB_DOCS_IMAGE_DIR_PATH=

  [ -f ~/.ustasbenv ] && source ~/.ustasbenv

# }}}

# === Aliases === {{{

  # Preserves aliases while using sudo.
  # https://askubuntu.com/a/22043
  alias sudo='sudo '

  # core
  alias ...='../..'
  alias c='clear'
  alias ll='ls -alh'
  alias cdd='cd ~/Desktop'

  # Vim
  alias sysvim='/usr/bin/vim'
  alias vim=$BU_EDITOR
  alias vi=$BU_EDITOR
  alias v=$BU_EDITOR
  alias gv='$BU_EDITOR -c "let g:startify_disable_at_vimenter = 1" -c Magit' # Git GUI

  # Ripgrep
  alias rg="rg $RIPGREP_ARGS"
  alias ag=rg

  # GPG
  # As of 11/08/17, Homebrew's gpg is version 2.x by default.
  if type gpg2 > /dev/null; then
    alias gpg='gpg2'
  fi
  alias bu_encrypt="gpg --encrypt --sign --local-user brianustas@gmail.com --recipient brianustas@gmail.com"
  alias bu_decrypt="gpg --decrypt --local-user brianustas@gmail.com"

  # misc tools
  alias tmuxk='tmux kill-server'
  alias work='bu_work -d' # pomodoro timer
  alias jp="jupyter notebook"

# }}}

# === Helper Functions === {{{

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

  todo() {
    vim \
    -c 'let g:startify_disable_at_vimenter = 1' \
    -c 'cd $USTASB_DOCS_DIR_PATH' \
    -c Todo \
    -c Tagbar \
    -c NERDTreeToggle \
    -c 'wincmd l'
  }
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

# }}}

# === Vendor === {{{

  # z
  source /usr/local/etc/profile.d/z.sh
  # Show a fzf prompt when no arguments are provided to z.
  # credit: https://github.com/junegunn/fzf/wiki/examples#integration-with-z
  unalias z 2> /dev/null
  z() {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 30% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  }

  # fzf
  export FZF_DEFAULT_OPTS='--reverse'
  export FZF_DEFAULT_COMMAND="rg $RIPGREP_ARGS --files --no-messages"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh  # Allow fzf to replace Ctrl-R, etc.

# }}}

# === GPG + SSH === {{{

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

# }}}

# === Hacks === {{{

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

# }}}

# === Local Customizations === {{{

  [ -f ~/.zshrc.local ] && source ~/.zshrc.local

# }}}

# === Default tmux Session === {{{

  startup_tasks() {
    start_gpg_agent

    # Things to happen after booting.
    # OS X cleans this directory upon shutdown.
    if [ ! -f /tmp/machine_booted ]; then
      touch /tmp/machine_booted
      bu_customize_finder_sidebar
    fi

    if [ -d $USTASB_UNENCRYPTED_DIR_PATH ]; then
      ln -sfn $USTASB_UNENCRYPTED_DIR_PATH $HOME/ustasb_encrypted
    else
      printf "\033[1;31m\`ustasb_encrypted\` Cryptomator drive not mounted\!\033[0m"
    fi
  }

  # Prefer tmux windows over iTerm tabs and windows.
  # I've told iTerm to ignore Command-T and Command-N.
  if [ $TERM_PROGRAM == 'iTerm.app' ]; then
    # If not in tmux yet...
    if [ -z "$TMUX" ]; then
      # Create or attach to the 'ustasb' tmux session.
      # -d to detach other clients.
      tmux attach -d -t ustasb 2>/dev/null || cd ~ && tnew ustasb
    else
      startup_tasks
    fi
  fi

# }}}
