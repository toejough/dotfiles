#! /usr/bin/env bash

# fail early
set -euo pipefail

# homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# fish
brew install fish

# actual install
~/dotfiles/install.fish
