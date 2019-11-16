#! /usr/bin/env fish

# fish configs
mkdir -p ~/.config/fish/functions
and ln -vFfs ~/dotfiles/.config/fish/config.fish ~/.config/fish
and ln -vFfs ~/dotfiles/.config/fish/functions/* ~/.config/fish/functions
# other configs
and ln -vFfs ~/dotfiles/.vimrc ~
and ln -vFfs ~/dotfiles/.gitconfig ~
and ln -vFfs ~/dotfiles/.tmux.conf ~
# nvim configs
and mkdir -p ~/.config/nvim
and ln -vFfs ~/dotfiles/.config/nvim/* ~/.config/nvim
# alacritty configs
and mkdir -p ~/.config/alacritty
and ln -vFfs ~/dotfiles/.config/alacritty/* ~/.config/alacritty

# brew-installable programs
and brewm update

# fish plugins
and fisher self-update
and fisher ls | fisher rm
and cat ~/dotfiles/fisher-list.txt | fisher add

# vim plugins
and pip3 install pynvim
and vim +ReloadRC  # don't quit - want to see what got updated sometimes
and vim +GoUpdateBinaries +qall

# final message
and echo "Updates completed!!"
or echo "Update FAILED (╯°□°）╯︵ ┻━┻ "
