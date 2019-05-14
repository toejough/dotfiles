# Editor
set -x EDITOR vim

# Set dirnext and dirprev and direction to universals
set -U dirprev $dirprev
set -U dirnext $dirnext
set -U __fish_cd_direction $__fish_cd_direction

# Enable post-exec
source ~/dotfiles/.config/fish/functions/post_exec.fish

# CD to last dir
cd $last_dir

# Update path to include go binaries
set PATH ~/go/bin:$PATH

# Update envvars per directory
direnv hook fish | source

# Prevent the press-and-hold key behavior
defaults write -g ApplePressAndHoldEnabled -bool false
