# Path to your oh-my-zsh installation.
export ZSH=/Users/mim/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
ZSH_THEME="mim"

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# so I can store my dot files on github and do config pull
alias config='/usr/local/bin/git --git-dir=/Users/mim/.dotfiles/ --work-tree=/Users/mim'

alias up='cd ..'