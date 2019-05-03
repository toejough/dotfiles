# Editor
set -x EDITOR vim

# added for pipx (https://github.com/cs01/pipx)
set -x PATH /Users/joe/.local/bin $PATH

# added by pipx
set -x PATH /Users/joe/.local/bin $PATH

# pyenv activation hooks
source (pyenv init -| psub)
source (pyenv virtualenv-init -| psub)
set -x PYENV_ROOT /Users/joe/.pyenv
set -x PYTHON_CONFIGURE_OPTS "--enable-framework"

# CD to last dir
cd $last_dir
