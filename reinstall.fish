#! /usr/bin/env fish

# fish configs
mkdir -p ~/.config/fish/functions
ln -vFfs ~/dotfiles/.config/fish/config.fish ~/.config/fish
ln -vFfs ~/dotfiles/.config/fish/functions/* ~/.config/fish/functions
# other configs
ln -vFfs ~/dotfiles/.vimrc ~
ln -vFfs ~/dotfiles/.gitconfig ~
ln -vFfs ~/dotfiles/.tmux.conf ~
# nvim configs
mkdir -p ~/.config/nvim
ln -vFfs ~/dotfiles/.config/nvim/* ~/.config/nvim

# brew-installable programs
brewm update

# fish plugins
fisher self-update
fisher ls | fisher rm
fisher add (cat ~/dotfiles/fisher-list.txt)

# vim plugins
vim -c ReloadRC
