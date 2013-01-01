# Brian Ustas's .bashrc
# .bashrc is used when the shell is not a login shell.
# My .bash_profile sources from this file.

# PS1
# Validate with: github.com/ustasb/ps1_lint
GIT_PROMPT_PATH=/usr/local/Cellar/git/1.8.0/etc/bash_completion.d/git-prompt.sh
if [ -f $GIT_PROMPT_PATH ]; then
  source $GIT_PROMPT_PATH
  export PS1='\[\e[0;32m\]\u:\[\e[0;35m\] \w\[\e[0;36m\]$(__git_ps1 " (%s)")\n\[\e[0;32m\]\$\[\e[0m\] '
else
  export PS1='\[\e[0;32m\]\u:\[\e[0;35m\] \w\n\[\e[0;32m\]\$\[\e[0m\] '
fi

# Homebrew
# /usr/local/bin should take precedence
export PATH=/usr/local/bin:$PATH

# RVM
PATH=$PATH:$HOME/.rvm/bin
source $HOME/.rvm/scripts/rvm

# MacVim is the default editor
export EDITOR='mvim -f'
