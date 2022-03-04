#!/bin/bash

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

  if [[ -f "$2" ]] || [[ -L "$2" ]]; then
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

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

nicecopy zsh/.zshrc ~

###############################################################################
# Homebrew                                                                    #
###############################################################################

nicelink Brewfile ~/Brewfile

# Install Homebrew if needed
if test ! $(which brew); then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew bundle install
brew cleanup

echo 'export PATH="/home/user/miniconda3/bin:$PATH"' >> ~/.zshrc

###############################################################################
# macOS                                                                       #
###############################################################################

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Save screenshots to the a screenshot directory
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

###############################################################################
# Git                                                                         #
###############################################################################

# Don't simlink .gitconfig so we can safely add `token` later
nicecopy github/gitconfig ~/.gitconfig 
nicelink github/gitignore ~/.gitignore

source ~/.zshrc