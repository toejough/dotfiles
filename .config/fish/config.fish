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
set -x fish_user_paths "/usr/local/opt/ruby@2.3/bin" $fish_user_paths

# pyenv activation hooks
# NOTE: something that happens above here breaks these calls if they're performed at the
#       top of the file.  Putting them here makes pyenv work as expected.
status --is-interactive; and source (pyenv init -| psub)
status --is-interactive; and source (pyenv virtualenv-init -| psub)
set -x PYENV_ROOT /Users/joe/.pyenv

# pipsi
set -x fish_user_paths ~/.local/bin $fish_user_paths
which pipsi ^&1 > /dev/null; or begin; echo "Pipsi not found.  Installing..."; and curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python; end

# pipenv
which pipenv ^&1 > /dev/null; or begin; echo "Pipenv not found.  Installing..."; and pipsi install pipenv; end
eval (pipenv --completion)
set -x PIPENV_SHELL_FANCY 1

# remove the vi cursor
function fish_vi_cursor; end
