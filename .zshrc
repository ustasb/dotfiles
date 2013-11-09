# Brian Ustas's .zshrc

#=== zsh Settings

  # Completion
  autoload -U compinit
  compinit

  # Automatically enter directories without cd
  setopt auto_cd

  # vi prompt mode
  bindkey -v
  bindkey jk vi-cmd-mode  # jk to enter normal mode

  # Add some readline keys back
  bindkey "^A" beginning-of-line
  bindkey "^E" end-of-line
  bindkey "^P" history-search-backward
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

#=== Aliases

  alias mkdir='mkdir -p'
  alias ...='../..'
  alias l='ls'
  alias ll='ls -alh'

  MY_VIM='mvim -v'
  alias sysvim='/usr/bin/vim'
  alias vi=$MY_VIM
  alias vim=$MY_VIM

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

  # Enable color constants
  autoload -U colors
  colors

  # Expand functions in the prompt
  setopt prompt_subst

  # VI mode indicator in ZSH prompt
  # Credit: Paul Goscicki
  vim_ins_mode="%F{242}I%{$reset_color%}"
  vim_cmd_mode="%F{242}N%{$reset_color%}"
  vim_mode=$vim_ins_mode

  function zle-keymap-select {
    vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
    zle reset-prompt
  }
  zle -N zle-keymap-select

  function zle-line-finish {
    vim_mode=$vim_ins_mode
  }
  zle -N zle-line-finish

  # Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
  # Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
  # Thanks Ron! (see comments)
  function TRAPINT() {
    vim_mode=$vim_ins_mode
    return $(( 128 + $1 ))
  }

  # Pure
  # Credit: Sindre Sorhus
  # fastest possible way to check if repo is dirty
  prompt_pure_git_dirty() {
    # check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    # check if it's dirty
    command git diff --quiet --ignore-submodules HEAD &>/dev/null

    (($? == 1)) && echo '*'
  }

  # displays the exec time of the last command if set threshold was exceeded
  prompt_pure_cmd_exec_time() {
    local stop=$(date +%s)
    local start=${cmd_timestamp:-$stop}
    integer elapsed=$stop-$start
    (($elapsed > ${PURE_CMD_MAX_EXEC_TIME:=5})) && echo ${elapsed}s
  }

  prompt_pure_preexec() {
    cmd_timestamp=$(date +%s)

    # shows the current dir and executed command in the title when a process is active
    print -Pn "\e]0;"
    echo -nE "$PWD:t: $2"
    print -Pn "\a"
  }

  # string length ignoring ansi escapes
  prompt_pure_string_length() {
    echo ${#${(S%%)1//(\%([KF1]|)\{*\}|\%[Bbkf])}}
  }

  prompt_pure_precmd() {
    # shows the full path in the title
    print -Pn '\e]0;%~\a'

    # git info
    vcs_info

    local prompt_pure_preprompt='\n%F{blue}%~%F{242}$vcs_info_msg_0_`prompt_pure_git_dirty` $prompt_pure_username%f %F{yellow}`prompt_pure_cmd_exec_time`%f'
    print -P $prompt_pure_preprompt

    # check async if there is anything to pull
    (( ${PURE_GIT_PULL:-1} )) && {
      # check if we're in a git repo
      command git rev-parse --is-inside-work-tree &>/dev/null &&
      # check check if there is anything to pull
      command git fetch &>/dev/null &&
      # check if there is an upstream configured for this branch
      command git rev-parse --abbrev-ref @'{u}' &>/dev/null &&
      (( $(command git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) &&
      # some crazy ansi magic to inject the symbol into the previous line
      print -Pn "\e7\e[A\e[1G\e[`prompt_pure_string_length $prompt_pure_preprompt`C%F{cyan}⇣%f\e8"
    } &!

    # reset value since `preexec` isn't always triggered
    unset cmd_timestamp
  }

  prompt_pure_setup() {
    prompt_opts=(cr subst percent)

    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    add-zsh-hook precmd prompt_pure_precmd
    add-zsh-hook preexec prompt_pure_preexec

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:git*' formats ' %b'
    zstyle ':vcs_info:git*' actionformats ' %b|%a'

    # show username@host if logged in through SSH
    [[ "$SSH_CONNECTION" != '' ]] && prompt_pure_username='%n@%m '

    # prompt turns red if the previous command didn't exit with 0
    PROMPT='${vim_mode} %(?.%F{magenta}.%F{red})❯%f '
  }

  prompt_pure_setup "$@"
