#!/bin/bash

# Homebrew
ln -s Brewfile ~/Brewfile

# Install Homebrew if needed
if test ! $(which brew); then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew bundle install
brew cleanup

# Add miniconda to PATH
export PATH="~/miniconda3/bin:$PATH"

# Git
# .gitconfig should not be simlinked so that
# a `token` can be added later without a security issue
cp github/.gitconfig ~/.gitconfig 
ln -s github/.gitignore ~/.gitignore

source ~/.zshrc