#! /usr/bin/env fish


mkdir -p ~/.config/fish
ln -vFfs ~/dotfiles/.config/fish/* ~/.config/fish
ln -vf ~/dotfiles/.config/fish/fishd.universal  ~/.config/fish/(ls ~/.config/fish | grep fishd | grep -v universal)
ln -vFfs ~/dotfiles/.vimrc ~
ln -vFfs ~/dotfiles/.gitconfig ~
ln -vFfs ~/dotfiles/.tmux.conf ~
brewm update
