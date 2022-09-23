# Personal Dotfiles

## Installation

1. Clone the repository, ideally to `~/.dotfiles`, but any directory location will do.
2. Run `source setup.sh`

## Overview

Each top-level directory in this repository (e.g., `git` or `homebrew`) is a _module_. A module is a collection of associated functionality. There are several types of files that can be placed inside a module:
- **Symlinks:** Any file `NAME.symlink` will be symlinked (`ln -s`) to `~/NAME`, removing only the `.symlink` extension and changing nothing else. Note then that if the file needs to have a dot in front (i.e., `.zshrc`) then the corresponding symlink file must have the dot in its name `.zshrc.symlink`.
- **Copies:** Similar to symlinks, but these files `NAME.copy` will simply be copied to `~/NAME`.
- **Install Scripts:** Any regular shell scripts `install.sh` which ought to be run. Use cases include:
  - Installing software (e.g., installing homebrew and then using homebrew to install software from the `Brewfile`)
  - Setting defaults in macOS
- **Path Files:** Any `path.zsh` will be loaded (`source`'d) by `.zshrc`, so any additions to `$PATH` can be put in these files.

## A note on `.zshrc`

`.zshrc` is the main zsh config file, and is responsible for quite a lot of the functionality here. In particular, it is `.zshrc` which processes the `path.zsh` files, not the `setup.sh` script. Additionally, `.zshrc` is responsible for:
- Loading any local environment variables from `~/.localrc` (which should never be tracked by git for privacy)
- Establishing aliases
- Formatting the prompt