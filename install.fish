#! /usr/bin/env fish

# fish plugins
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# update dirs/configs/packages
~/dotfiles/update.fish
