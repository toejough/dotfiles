# Shell integrations
#source ~/.iterm2_shell_integration.fish
#function iterm2_print_user_vars
#    set -l git_branch (git branch ^/dev/null | sed -n '/\* /s///p')
#    set -l venv (basename $VIRTUAL_ENV ^/dev/null)
#    set -l pyversion (python --version ^/dev/null; or echo "No python")
#    iterm2_set_user_var cur_dir (basename (pwd))
#    iterm2_set_user_var git_branch (test -n "$git_branch"; and echo "Branch: $git_branch"; or echo "No branch")
#    iterm2_set_user_var venv (test -n "$venv"; and echo "Venv: $venv"; or echo "No venv")
#    iterm2_set_user_var pyversion "$pyversion"
#end

# Editor
set -x EDITOR vim

# Rust (for alacritty)
set PATH $PATH /Users/joe/.cargo/bin

# android
set -x ANDROID_HOME ~/Library/Android/sdk

# CD to the last known directory
if test -e $last_dir
    cd $last_dir
end

# pyenv activation hooks
# NOTE: something that happens above here breaks these calls if they're performed at the
#       top of the file.  Putting them here makes pyenv work as expected.
status --is-interactive; and source (pyenv init -| psub)
status --is-interactive; and source (pyenv virtualenv-init -| psub)
set -x PYENV_ROOT /Users/joe/.pyenv
set -x PYTHON_CONFIGURE_OPTS "--enable-framework"

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
#[ -f /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.fish ]; and . /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.fish

# added by pipsi (https://github.com/mitsuhiko/pipsi)
set -x PATH /Users/joe/.local/bin $PATH
