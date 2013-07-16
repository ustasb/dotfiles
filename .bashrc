# Brian Ustas's .bashrc
# .bashrc is used when the shell is not a login shell.
# My .bash_profile sources from this file.

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
  export PS1='\[\e[0;34m\]\u:\[\e[0;36m\] \w\[\e[0;34m\]$(__git_ps1 " (%s)")\n\[\e[0;34m\]\$\[\e[0m\] '
else
  export PS1='\[\e[0;34m\]\u:\[\e[0;36m\] \w\n\[\e[0;34m\]\$\[\e[0m\] '
fi

# Homebrew
export PATH=/usr/local/bin:$PATH
# NPM
export PATH=/usr/local/share/npm/bin:$PATH
# RVM
PATH=$PATH:$HOME/.rvm/bin
source $HOME/.rvm/scripts/rvm

# Make MacVim the default editor.
alias sysvim='/usr/bin/vim'
alias vi='mvim -v'  # Run MacVim in the terminal.
alias vim='mvim -v'
export EDITOR='mvim -f'

alias g+='g++-4.8 -std=c++11'

# Prevent bold font in Vim within tmux.
[ -n "$TMUX" ] && export TERM=screen-256color
