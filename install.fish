#! /usr/bin/env fish


mkdir -p ~/.config/fish
ln -vFfs ~/.settings/.config/fish/* ~/.config/fish
ln -vf ~/.settings/.config/fish/fishd.universal  ~/.config/fish/(ls ~/.config/fish | ack fishd | ack -v universal)
