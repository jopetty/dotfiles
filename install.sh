#!/bin/bash

###############################################################################
# Helper Functions                                                            #
###############################################################################

CURRENT_DIR=$(pwd -P)

function info {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

function warn {
  printf "\r  [ \033[0;33m!!\033[0m ] $1\n"
}

function nicelink {
  if [[ ! -d ~/.dotfiles_backup ]]; then
    mkdir ~/.dotfiles_backup
  fi

  if [[ -f "$2" ]] || [[ -L "$2" ]] || [[ -d "$2" ]]; then
    if [[ "$(readlink $2)" == "$1" ]]; then
      info "$2 is already linked to $1"
      return 0
    fi
    oldpath=$2:t
    warn "Overwriting $2 (backup at ~/dotfiles_backup/$oldpath)"
    mv $2 ~/dotfiles_backup/
  fi
  info "Simlinking $1 to $2"
  ln -s $1 $2
}

function nicecopy {
  if [[ ! -d ~/dotfiles_backup ]]; then
    mkdir ~/dotfiles_backup
  fi

  if [[ -f "$2" ]]; then
    oldpath=$2:t
    warn "Overwriting $2 (backup at ~/dotfiles_backup/$oldpath)"
    mv $2 ~/dotfiles_backup/
  fi
  info "Copying $1 to $2"
  cp $1 $2
}


###############################################################################
# Installation                                                                #
###############################################################################

# Homebrew
if test ! $(which brew); then
  info "\r Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
nicelink $CURRENT_DIR/Brewfile $HOME/Brewfile
brew update
brew upgrade
brew tap homebrew/bundle
brew bundle install --file=~/Brewfile
brew cleanup

# After Homebrew
ghcup install ghc && ghcup set ghc  # Haskell (via ghcup)
raco install pollen                 # Pollen (via raco/racket)

# iterm2
nicelink $CURRENT_DIR/iterm2.plist $HOME/Library/Preferences/com.googlecode.iterm2.plist

# Git
nicecopy $CURRENT_DIR/gitconfig $HOME/.gitconfig
nicelink $CURRENT_DIR/gitignore $HOME/.gitignore

###############################################################################
# fin                                                                         #
###############################################################################

exec zsh
