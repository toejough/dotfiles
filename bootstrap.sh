#! /usr/bin/env bash

# fail early
set -euo pipefail

# xcode devtools
echo "Installing XCode devtools..."
xcode-select --install || echo "assuming error means installed. moving on..."

# homebrew
echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "Installing shell env vars to bash..."
eval "$(/opt/homebrew/bin/brew shellenv)"

# fish
echo "Installing fish shell..."
brew install fish

# actual install
echo "Running install.fish..."
~/dotfiles/install.fish
