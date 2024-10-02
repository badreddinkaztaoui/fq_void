#!/bin/bash

setup_bash_profile() {
  echo "Setting up .bash_profile ..."

  if [ -f "~/.bash_profile" ]; then
    cp ~/.bash_profile ~/.bash_profile.backup
    echo "Existing .bash_profile backed up to ~/.bash_profile.backup"
  fi

  cat > ~/.bash_profile << EOL
 [ -f $HOME/.bashrc ] && .$HOME/.bashrc

 export BROWSER="firefox"
 export TERMINAL="st"
 export TERM="st"

 [[ $(tty) = "/dev/tty1" ]] && startx
EOL

  echo ".bash_profile setup complete!"
}

setup_bashrc() {
  echo "Setting up .bashrc ..."

  if [ -f  "~/.bashrc" ]; then
      cp ~/.bashrc ~/.bashrc.backup
      echo "Existing .bashrc backed up to ~/.bashrc.backup"
  fi

  cat > ~/.bashrc << EOL
# .bashrc

# If not running interactively, don't do anything

# [[ "$-" != *i* ]] && return

PS1="\[\033[1;34m\] ~ \[\033[0m\]\[\033[1;32m\]>\[\033[0m\] "

# General aliases
alias ll='ls -l --color=auto'
alias lshd='find . -maxdepth 1 -type d -name ".*"'
alias lshf='find . -maxdepth 1 -type f -name ".*"'

# xbps aliases
alias i='doas xbps-install -S'
alias u='i; doas xbps-install -u xbps; doas xbps-install -u'
alias q='doas xbps-query -Rs'
alias r='doas xbps-remove -R'

# Git aliases
alias grao='git remote add origin'
alias gcl='git clone'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push -u'

# Services aliases
alias status='doas sv status'
alias start='doas sv start'
alias stop='doas sv stop'
alias restart='doas sv restart'

# Applications aliases
alias vi='vim'
alias copy='xclip -selection clipboard'

set -o vi
EOL

  echo ".bashrc setup complete!"
}

setup_bashrc
setup_bash_profile

source ~/.bashrc
