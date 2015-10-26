function update-all() {
    update-brew
    update-spf13
    update-pip
    update-npm
    update-gem
}

function update-gem() {
	if [ -n $(which gem) ]; then
		log-rc 'updating ruby packages via gem...'
		gem outdated | cut -d' ' -f1 | xargs -L1 gem update | grep -v 'Updating installed gems'
	fi
}

function update-npm() {
	if [ -n $(which npm) ]; then
		log-rc 'updating node packages via npm...'
		npm -g update npm
		npm -g outdated --parseable --depth=0 | cut -d: -f3 | xargs -L1 npm -g install
	fi
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
