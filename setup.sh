#!/bin/bash

DOTFILES_ROOT=$(pwd -P)

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
    oldpath=$2:t
    warn "Overwriting $2 (backup at ~/.dotfiles_backup/$oldpath)"
    mv $2 ~/.dotfiles_backup/
  fi
  info "Simlinking $1 to $2"
  ln -s $1 $2
}

function nicecopy {
  if [[ ! -d ~/.dotfiles_backup ]]; then 
    mkdir ~/.dotfiles_backup
  fi

  if [[ -f "$2" ]]; then
    oldpath=$2:t
    warn "Overwriting $2 (backup at ~/.dotfiles_backup/$oldpath)"
    mv $2 ~/.dotfiles_backup/
  fi
  info "Copying $1 to $2"
  cp $1 $2
}

###############################################################################
# Copy & Link Dotfiles                                                        #
###############################################################################

# Symlink all *.symlink files
for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink')
do 
  dst="$HOME/$(basename "${src%.*}")"
  nicelink "$src" "$dst"
done

# Copy all *.copy files
for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.copy')
do 
  dst="$HOME/$(basename "${src%.*}")"
  nicecopy "$src" "$dst"
done

###############################################################################
# Run Install Scripts                                                         #
###############################################################################

find . -name install.sh | while read installer ; do sh -c "${installer}" ; done

exec zsh
