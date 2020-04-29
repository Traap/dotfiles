#!/bin/bash
#----------------------------------------------------------------------
# Don't do anything when not running interactively.
#----------------------------------------------------------------------
[ -z "$PS1" ] && return

#----------------------------------------------------------------------
# Source my dotfiles personalized environment.
#----------------------------------------------------------------------
if [ -f ~/git/dotfiles/bashrc-personal ]; then
  source ~/git/dotfiles/bashrc-personal
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
