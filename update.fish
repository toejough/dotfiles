#! /usr/bin/env fish

# get the latest
if cd ~/dotfiles; and git fetch > /dev/null; and git status | grep -i 'your branch is up to date' > /dev/null
    echo (set_color cyan)"Copying homedir configs..."(set_color normal)
    and ln -vFfs ~/dotfiles/.vimrc ~
    and ln -vFfs ~/dotfiles/.gitconfig ~
    and ln -vFfs ~/dotfiles/.tmux.conf ~

    echo (set_color cyan)"Copying fish configs..."(set_color normal)
    mkdir -p ~/.config/fish/functions
    and ln -vFfs ~/dotfiles/.config/fish/config.fish ~/.config/fish
    and ln -vFfs ~/dotfiles/.config/fish/functions/* ~/.config/fish/functions

    echo (set_color cyan)"Copying nvim configs..."(set_color normal)
    and mkdir -p ~/.config/nvim
    and ln -vFfs ~/dotfiles/.config/nvim/* ~/.config/nvim

    echo (set_color cyan)"Copying alacritty configs..."(set_color normal)
    and mkdir -p ~/.config/alacritty
    and ln -vFfs ~/dotfiles/.config/alacritty/* ~/.config/alacritty

    echo (set_color cyan)"Updating brew packages..."(set_color normal)
    and brewm update

    echo (set_color cyan)"Updating fisher plugins..."(set_color normal)
    and fisher self-update
    and fisher ls | fisher rm
    and cat ~/dotfiles/fisher-list.txt | fisher add

    echo (set_color cyan)"Updating nvim plugins..."(set_color normal)
    and pip3 install neovim
    and vim +ReloadRC  # don't quit - want to see what got updated sometimes
    #and vim -c "CocInstall coc-json coc-vimlsp coc-markdownlint coc-xml" +qall

    echo (set_color cyan)"Updating global go binaries..."(set_color normal)
    and go get golang.org/x/tools/gopls@latest
    and go get golang.org/x/tools/cmd/goimports
    and go get github.com/GoogleCloudPlatform/cloudsql-proxy/cmd/cloud_sql_proxy

    echo (set_color cyan)"Updating global js binaries..."(set_color normal)
    and npm install -g npm
    #and npm install -g yarn

    echo (set_color cyan)"Updating gcloud..."(set_color normal)
    and gcloud components update

    # final message
    and echo (set_color green)"Updates completed!!"(set_color normal)
    or echo (set_color red)"Update FAILED (╯°□°）╯︵ ┻━┻ "(set_color normal)
else
    cd ~/dotfiles
    echo (set_color yellow)"Updating the update script..."(set_color normal)
    git pull
    git push
    and ./update.fish
end
