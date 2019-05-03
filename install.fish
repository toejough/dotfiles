#! /usr/bin/env fish


mkdir -p ~/.config/fish
ln -vFfs ~/dotfiles/.config/fish/* ~/.config/fish
ln -vf ~/dotfiles/.config/fish/fishd.universal  ~/.config/fish/(ls ~/.config/fish | ack fishd | ack -v universal)
