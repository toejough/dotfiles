# Editor
set -x EDITOR vim

# Rust (for alacritty)
set PATH $PATH /Users/joe/.cargo/bin

# android
set -x ANDROID_SDK_ROOT "/usr/local/share/android-sdk"

# added for pipx (https://github.com/cs01/pipx)
set -x PATH /Users/joe/.local/bin $PATH

# pyenv activation hooks
# NOTE: something that happens above here breaks these calls if they're performed at the
#       top of the file.  Putting them here makes pyenv work as expected.
#status --is-interactive; and source (pyenv init -| psub)
#status --is-interactive; and source (pyenv virtualenv-init -| psub)
source (pyenv init -| psub)
source (pyenv virtualenv-init -| psub)
set -x PYENV_ROOT /Users/joe/.pyenv
set -x PYTHON_CONFIGURE_OPTS "--enable-framework"

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
#[ -f /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.fish ]; and . /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.fish


# Set cd history universally
set -U dirprev
set -U dirnext
