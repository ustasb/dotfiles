# Brian Ustas's .bashrc
# .bashrc is used when the shell is not a login shell.
# My .bash_profile sources from this file.

uname_str=$(uname)

# Assumes Git was installed via Homebrew.
GIT_COMPLETION_PATH=/usr/local/Cellar/git/*/etc/bash_completion.d/git-completion.bash
if [ -f $GIT_COMPLETION_PATH ]; then
  source $GIT_COMPLETION_PATH
fi

# PS1
# Validate with: github.com/ustasb/ps1_lint
GIT_PROMPT_PATH=/usr/local/Cellar/git/*/etc/bash_completion.d/git-prompt.sh
if [ -f $GIT_PROMPT_PATH ]; then
  GIT_PS1_SHOWDIRTYSTATE=true  # staged (+) vs unstaged (*)
  GIT_PS1_SHOWUNTRACKEDFILES=true  # shown by: %
  source $GIT_PROMPT_PATH
  export PS1='\[\e[0;34m\]\u@\h:\[\e[0;36m\] \w\[\e[0;34m\]$(__git_ps1 " (%s)")\n\[\e[0;34m\]\$\[\e[0m\] '
else
  export PS1='\[\e[0;34m\]\u@\h:\[\e[0;36m\] \w\n\[\e[0;34m\]\$\[\e[0m\] '
fi

# NPM
export PATH=/usr/local/share/npm/bin:$PATH
# Homebrew
export PATH=/usr/local/bin:$PATH
# rbenv
eval "$(rbenv init -)"

# Aliases
alias ls='ls -p' # Append / to directories
alias be='bundle exec'
alias g+='g++-4.8 -std=c++11'

alias sysvim='/usr/bin/vim'
# OS X
if [[ $uname_str == 'Darwin' ]]; then
  alias vim='mvim -v'  # Run MacVim in the terminal
fi
alias vi='vim'
export EDITOR='vim'
