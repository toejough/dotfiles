#! /usr/bin/env fish

# fish plugins
echo "Installing fisher..."
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# expected prereqs to the update script
echo "Installing update prereqs..."
brew install ack gsed

# update dirs/configs/packages
echo "Running update.fish..."
~/dotfiles/update.fish
