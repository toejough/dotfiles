function update-all() {
    update-brew
    update-spf13
    update-pip
}

function update-pip() {
    if [ -n $(which pip) ]; then
        log-rc 'updating python packages via pip...'
        pip3 install -U pip
        pip3 list -o | cut -d ' ' -f 1 | xargs -L1 pip3 install -U
    else
        log-rc 'NOT updating python packages - pip not found.'
    fi
}

function update-spf13() {
    if [ -n $(which vim) ]; then
        log-rc 'updating vim plugins via spf13-vim...'
        bash <(curl https://j.mp/spf13-vim3 -L)
    else
        log-rc 'NOT updating vim plugins - vim not found.'
    fi
}

function update-brew() {
    if [ -n $(which brew) ]; then
        log-rc 'updating brewed packages via homebrew...'
        brew update
        brew upgrade --all
        brew prune
        brew cleanup -s
        brew doctor
    else
        log-rc 'NOT updating brewed packages - homebrew not found.'
    fi
}
