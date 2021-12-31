# Brian Ustas's .zshrc
#
# Tested on OS X.
#
# Expected installs:
# - Homebrew (https://brew.sh)
# - Neovim (https://neovim.io)
# - Git
# - rbenv (https://github.com/rbenv/rbenv)
# - Conda via Anaconda (https://conda.io/docs/user-guide/install)
# - n and a Node.js version (https://github.com/tj/n)
# - Pure Prompt (https://github.com/sindresorhus/pure)
# - fzf (https://github.com/junegunn/fzf)
# - z ( https://github.com/rupa/z)
# - gpg2 (https://www.gnupg.org)
# - rg (https://github.com/BurntSushi/ripgrep)
# - bat (https://github.com/sharkdp/bat): Used by fzf.vim's preview.

# === zsh Settings === {{{

  # completion
  autoload -U compinit
  compinit

  # Use Emacs as the command line editor.
  # Makes some keys work within tmux.
  bindkey -e

  # Keep lots of history.
  export HISTFILE=~/.zsh_history
  export HISTSIZE=5000
  export SAVEHIST=5000

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
    branches=$(git branch --sort=-committerdate) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | sed "s/.* //")
  }

  # Ensure that bat syntax highlighting looks good regardless of the terminal theme.
  # https://github.com/sharkdp/bat
  set_bat_theme_env_var() {
    if ! command -v bat &> /dev/null; then
      echo "The bat command is not installed!"
    fi

    # NOTE: ansi-light/dark have issues where the --highlight-line is unreadable (it's all black).
    # The temporary fix is to use the OneHalfLight and base16 themes which highlight lines properly (during fzf's :Rg in Vim, for instance)
    if [[ "$ITERM_PROFILE" == "GruvboxLight" ]]; then
      export BAT_THEME="OneHalfLight"
      # export BAT_THEME="ansi-light"
    else
      export BAT_THEME="base16"
      # export BAT_THEME="ansi-dark"
    fi
  }

  # Changes the iTerm profile.
  update_iterm_color_profile() {
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
    set_bat_theme_env_var
    update_iterm_color_profile $ITERM_PROFILE
  }

  light_theme() {
    export ITERM_PROFILE=GruvboxLight
    if [ -n "$TMUX" ]; then
      tmux set-environment ITERM_PROFILE $ITERM_PROFILE
      tmux source-file ~/dotfiles/tmux/gruvbox_light_theme.conf
    fi
    set_bat_theme_env_var
    update_iterm_color_profile $ITERM_PROFILE
  }

  # Enable access to my personal scripts.
  # Helper functions are prefixed with `bu_`.
  source ~/dotfiles/scripts/shell_functions.sh

# }}}

# === Prompt === {{{

  export PURE_GIT_PULL=0
  fpath+=$HOME/.zsh/pure
  autoload -U promptinit && promptinit
  prompt pure

# }}}

# === Environment Variables === {{{

  # Homebrew
  export PATH=/usr/local/bin:$PATH

  # Ripgrep
  export RIPGREP_ARGS="--no-ignore-vcs --hidden --follow --smart-case --ignore-file-case-insensitive --ignore-file $HOME/.rgignore"

  # Use Neovim as the default editor.
  export BU_EDITOR="nvim"
  export VISUAL=$BU_EDITOR
  export EDITOR=$BU_EDITOR

  # Ruby via Rbenv
  eval "$(rbenv init -)"

  # Node.js via https://github.com/tj/n
  # Added by n-install (see http://git.io/n-install-repo).
  export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

  # Python via Anaconda
  export PATH=/usr/local/anaconda3/bin:"$PATH"

  set_bat_theme_env_var

# }}}

# === ustasb ENV Template === {{{

  # Add these to ~/.ustasbenv

  # export USTASB_AWS_ACCESS_KEY_ID=
  # export USTASB_AWS_SECRET_ACCESS_KEY=
  # export USTASB_AWS_REGION=

  # `bu_back_up_gdrive`
  # export USTASB_S3_BACKUP_BUCKET_NAME=
  # export USTASB_CLOUD_DIR_PATH=
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

  # Ripgrep
  alias rg="rg $RIPGREP_ARGS"

  # GPG
  # As of 11/08/17, Homebrew's gpg is version 2.x by default.
  if type gpg2 > /dev/null; then
    alias gpg='gpg2'
  fi
  alias bu_encrypt="gpg --encrypt --sign --local-user brianustas@gmail.com --recipient brianustas@gmail.com"
  alias bu_decrypt="gpg --decrypt --local-user brianustas@gmail.com"

  # misc
  alias dot='cd ~/dotfiles'
  alias notes='cd "$USTASB_DOCS_DIR_PATH"'
  # kill tmux
  alias tmuxk='tmux kill-server'
  # kill all other tmux windows
  alias tmuxo='tmux kill-window -a'
  alias pt="ptpython"
  alias jp="jupyter notebook"
  alias pyserver="python -m http.server"

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

  # The remote system might not have TERM=tmux-256color in its database.
  alias ssh="TERM=xterm-256color ssh"

  set_gpg_agent_env_vars() {
    export GPG_TTY=$(tty)

    # Point the SSH_AUTH_SOCK to the one handled by gpg-agent.
    if [ -S $(gpgconf --list-dirs agent-ssh-socket) ]; then
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    else
      echo "$(gpgconf --list-dirs agent-ssh-socket) doesn't exist. Is gpg-agent running?"
    fi
  }

  restart_gpg_agent() {
    # Kill gpg-agent
    gpgconf --kill gpg-agent
    # Launch gpg-agent
    gpg-connect-agent /bye &>/dev/null
    if [ $? -eq 0 ]; then
      printf "\033[1;32m\ngpg-agent has started!\n\033[0m"
    fi
    set_gpg_agent_env_vars
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
        echo "==> Done!"
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
    # Things to happen after booting.
    # OS X cleans this directory upon shutdown.
    if [ ! -f $TMPDIR/bu_machine_booted ]; then
      touch $TMPDIR/bu_machine_booted

      restart_gpg_agent

      bu_customize_finder_sidebar &> /dev/null
    else
      set_gpg_agent_env_vars
    fi

    if [ -d $USTASB_UNENCRYPTED_DIR_PATH ]; then
      if [ ! -d $HOME/ustasb_encrypted ]; then
        ln -s $USTASB_UNENCRYPTED_DIR_PATH $HOME/ustasb_encrypted
      fi
    else
      printf "\033[1;31m\n\`ustasb_encrypted\` Cryptomator drive not mounted!\n\033[0m"
    fi
  }

  # Prefer tmux windows over iTerm tabs and windows.
  # I've told iTerm to ignore Command-T and Command-N.
  if [ "$TERM_PROGRAM" == 'iTerm.app' ]; then
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
