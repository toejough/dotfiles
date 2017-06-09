# Shell integrations
source ~/.iterm2_shell_integration.fish
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)

# Editor
set -g EDITOR vim
