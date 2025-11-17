#! /usr/bin/env fish

# fish plugins
echo "Installing fisher..."
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# expected prereqs to the update script
echo "Installing update prereqs..."
brew install ack gsed

# update dirs/configs/packages
echo "Running update.fish..."
~/dotfiles/update.fish
