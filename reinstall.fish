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
# alacritty configs
mkdir -p ~/.config/alacritty
ln -vFfs ~/dotfiles/.config/alacritty/* ~/.config/alacritty

# brew-installable programs
brewm update

# fish plugins
fisher self-update
fisher ls | fisher rm
cat ~/dotfiles/fisher-list.txt | fisher add

# vim plugins
vim -c ReloadRC
