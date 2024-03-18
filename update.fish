#! /usr/bin/env fish

# get the latest
if cd ~/dotfiles; and git fetch >/dev/null; and git status | grep -i 'your branch is up to date' >/dev/null
    echo (set_color cyan)"Copying homedir configs..."(set_color normal)
    and ln -vFfs ~/dotfiles/.vimrc ~
    and ln -vFfs ~/dotfiles/.gitconfig ~
    and ln -vFfs ~/dotfiles/.tmux.conf ~

    and echo (set_color cyan)"Copying fish configs..."(set_color normal)
    and mkdir -p ~/.config/fish/functions
    and ln -vFfs ~/dotfiles/.config/fish/config.fish ~/.config/fish
    and ln -vFfs ~/dotfiles/.config/fish/functions/* ~/.config/fish/functions

    and echo (set_color cyan)"Copying nvim configs..."(set_color normal)
    and mkdir -p ~/.config/nvim
    and ln -vFfs ~/dotfiles/.config/nvim/* ~/.config/nvim

    and echo (set_color cyan)"Copying alacritty configs..."(set_color normal)
    and mkdir -p ~/.config/alacritty
    and ln -vFfs ~/dotfiles/.config/alacritty/* ~/.config/alacritty

    and echo (set_color cyan)"Updating brew packages..."(set_color normal)
    and brewm update

    and echo (set_color cyan)"Updating fisher plugins..."(set_color normal)
    and fisher update (fisher list)

    and echo (set_color cyan)"Updating nvim plugins..."(set_color normal)
    # and pip3 install --upgrade pip
    # and pip3 install neovim
    and nvim --headless "+Lazy! sync" +qa

    and echo (set_color cyan)"Updating global go binaries..."(set_color normal)
    and go install golang.org/x/tools/gopls@latest
    and go install golang.org/x/tools/cmd/goimports@latest
    and go install github.com/GoogleCloudPlatform/cloud-sql-proxy/v2@latest

    and echo (set_color cyan)"Updating global js binaries..."(set_color normal)
    and nvm install latest
    and npm install -g npm

    and echo (set_color cyan)"Updating gcloud..."(set_color normal)
    and brew upgrade google-cloud-sdk
    and gcloud components update

    # final message
    and echo (set_color green)"Updates completed!!"(set_color normal)
    or echo (set_color red)"Update FAILED (╯°□°）╯︵ ┻━┻ "(set_color normal)
else
    cd ~/dotfiles
    and echo (set_color yellow)"Updating the update script..."(set_color normal)
    and git pull
    and git push
    and ./update.fish
end
