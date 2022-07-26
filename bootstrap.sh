#! /usr/bin/env bash

# fail early
set -euo pipefail

# homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# fish
#brew install fish
brew install ack

# actual install
~/dotfiles/install.fish
