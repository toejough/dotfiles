#! /usr/bin/env fish

# configs
mkdir -p ~/.config/fish
ln -vFfs ~/dotfiles/.config/fish/* ~/.config/fish
ln -vf ~/dotfiles/.config/fish/fishd.universal  ~/.config/fish/(ls ~/.config/fish | grep fishd | grep -v universal)
ln -vFfs ~/dotfiles/.vimrc ~
ln -vFfs ~/dotfiles/.gitconfig ~
ln -vFfs ~/dotfiles/.tmux.conf ~
mkdir -p ~/.config/nvim
ln -vFfs ~/dotfiles/.config/nvim/* ~/.config/nvim

# brew-installable programs
brewm update

# fish plugins
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fisher add (cat ~/dotfiles/fisher-list.txt)

# vim plugins
vim -c ReloadRC
