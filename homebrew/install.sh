#!/bin/bash

# Install Homebrew if needed
if test ! $(which brew); then
  echo "\r Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew upgrade
brew tap homebrew/bundle
brew bundle install --file=~/Brewfile
brew cleanup

exit 0
