# Brian Ustas's .zshrc
#
# Supports OS X and Linux (tested with Sierra and Ubuntu 14.04).
#
### Expected Installs
#
# General:
# - Vim
# - Git
# - chruby and a Ruby version (https://github.com/postmodern/chruby)
# - n and a Node.js version (https://github.com/tj/n)
# - Pure Prompt (https://github.com/sindresorhus/pure)
# - fzf (https://github.com/junegunn/fzf)
# - z ( https://github.com/rupa/z)
# - gpg2 (https://www.gnupg.org)
#
# Mac Specific:
# - Homebrew

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

  # Keep lots of history.
  export HISTSIZE=1000
  export SAVEHIST=1000
  export HISTFILE=~/.history

  # Share history between terminals.
  setopt inc_append_history
  setopt share_history
  setopt hist_ignore_all_dups

  # Automatically cd into directories.
  setopt autocd

  # No beeping.
  unsetopt beep

  # Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation.
  setopt EXTENDED_GLOB

  # If a pattern for filename generation has no matches, print an error.
  unsetopt nomatch

  # Enable colored output from `ls`.
  export CLICOLOR=1

#=== Environment Variables

  # Use Vim as the visual editor.
  export VISUAL=vim
  export EDITOR=$VISUAL

  # Homebrew
  if [[ $platform == 'mac' ]]; then
    export PATH=/usr/local/bin:$PATH
  fi

  # chruby
  source '/usr/local/share/chruby/chruby.sh'
  source '/usr/local/share/chruby/auto.sh'

  # To hold zsh functions.
  fpath=("$HOME/.zfunctions" $fpath)

  # z
  source /usr/local/etc/profile.d/z.sh

  # fzf
  export FZF_DEFAULT_OPTS='--reverse'
  export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'  # Respects .gitignore
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh  # Allow fzf to replace Ctrl-R, etc.

  # fzf + z
  zz() {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --reverse --inline-info +s --tac --query "$*" | sed 's/^[0-9,.]* *//')"
  }

#=== Aliases

  alias ...='../..'
  alias c='clear'
  alias ll='ls -alh'
  alias cdd='cd ~/Desktop'
  alias tmuxk='tmux kill-server'

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

  # Ag
  alias ag='ag --hidden'

  # PGP
  alias encrypt="gpg --encrypt --sign --local-user brianustas@gmail.com --recipient brianustas@gmail.com"
  alias decrypt="gpg --decrypt --local-user brianustas@gmail.com"

  # GPG2
  # As of 11/08/17, Homebrew's gpg is version 2.x by default.
  if type gpg2 > /dev/null; then
    alias gpg='gpg2'
  fi

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
  compdef g=git  # Complete `g` like `git`

  # Create a new named tmux session with my preferred layout.
  tnew() { tmux new-session -s $1 \; \
                split-window -v -p 30 \; \
                split-window -h -p 66 \; \
                split-window -h -p 50 \; \
                select-pane -t 0 }

  # Checkout a Git branch with fzf.
  fbr() {
    local branches branch
    branches=$(git branch) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | sed "s/.* //")
  }

  # Fuzzy-search for a file and open in Vim.
  vv() {
    IFS='
  '
    local declare files=($(fzf --query="$1" --select-1 --exit-0))
    [[ -n "$files" ]] && vim "${files[@]}"
    unset IFS
  }

  # Create Cryptomator drive symbolic links.
  symlink_cryptomator() {
    ruby ~/dotfiles/scripts/create_cryptomator_symlinks.rb
  }

  # Back up Google Drive contents to S3.
  back_up_gdrive() {
    ruby ~/dotfiles/scripts/back_up_gdrive.rb
  }

  # Back up Photo Booth to the Cloud.
  back_up_photo_booth() {
    ruby ~/dotfiles/scripts/backup_photo_booth.rb
  }

#=== Prompt

  autoload -U promptinit && promptinit

  prompt pure

#=== GPG + SSH

  start_gpg_agent() {
    # Launch gpg-agent
    gpg-connect-agent /bye

    # When using SSH support, use the current TTY for passphrase prompts.
    gpg-connect-agent updatestartuptty /bye > /dev/null

    # Point the SSH_AUTH_SOCK to the one handled by gpg-agent.
    if [ -S $(gpgconf --list-dirs agent-ssh-socket) ]; then
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    else
      echo "$(gpgconf --list-dirs agent-ssh-socket) doesn't exist. Is gpg-agent running?"
    fi
  }

  restart_gpg_agent() {
    pkill gpg-agent
    start_gpg_agent
  }

  start_gpg_agent

#=== ENV Template

  # Add these to your ~/.zshrc.local

  # export USTASB_AWS_ACCESS_KEY_ID=
  # export USTASB_AWS_SECRET_ACCESS_KEY=
  # export USTASB_AWS_REGION=

  # For `symlink_cryptomator` and `back_up_gdrive`
  # export USTASB_CRYPTOMATOR_MOUNTED_DRIVE_NAME=
  # export USTASB_UNENCRYPTED_SYM_LINK_PATH=
  # export USTASB_NOTES_PATH=
  # export USTASB_ENCRYPTED_FOLDER_REL_PATH=
  # export USTASB_S3_BACKUP_BUCKET_NAME=

#=== Local Customizations

  [ -f ~/.zshrc.local ] && source ~/.zshrc.local
