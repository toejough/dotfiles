#! /usr/bin/env bash

# fail early
set -euo pipefail

# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# fish
brew install fish

# actual install
~/dotfiles/install.fish
