if status --is-interactive
    # Editor
    # Checking if we have already inherited an editor
    if ! set -q EDITOR
        # if not, use Vim
        set -x EDITOR nvim
    end

    # keybindings
    fish_vi_key_bindings

    # Set dirnext and dirprev and direction to universals
    set -U dirprev $dirprev
    set -U dirnext $dirnext
    set -U __fish_cd_direction $__fish_cd_direction

    # set initial directories
    if not set -q last_dir
        set -U last_dir (pwd)
    end

    # Enable post-exec
    source ~/dotfiles/.config/fish/functions/post_exec.fish

    # CD to last dir
    cd $last_dir

    # Prevent the press-and-hold key behavior
    defaults write -g ApplePressAndHoldEnabled -bool false

end

# Update path to include go binaries
set -x GOPATH ~/go
set -x PATH $GOPATH/bin:$PATH
set -x GO111MODULE on

# Update path to include local binaries
set -x PATH ~/.local/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/google-cloud-sdk/path.fish.inc' ]; . '~/google-cloud-sdk/path.fish.inc'; end
