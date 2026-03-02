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

    # Prevent the press-and-hold key behavior
    defaults write -g ApplePressAndHoldEnabled -bool false

end

# Update path to include go binaries
set -x GOPATH ~/go
fish_add_path $GOPATH/bin
set -x GO111MODULE on

# Update path to include local binaries
fish_add_path ~/.local/bin

# add a java home for android dev
set -x JAVA_HOME "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
set -x ANDROID_HOME "~/Library/Android/sdk"
set -x ANDROID_SDK_ROOT "~/Library/Android/sdk"
fish_add_path $ANDROID_SDK_ROOT/tools $ANDROID_SDK_ROOT/platform-tools

# Update path to include brew binaries, if they exist
if test -e /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Set bat/delta theme to solarized dark by default
set -x BAT_THEME "Solarized (dark)"

# Tell FZF to use fzf.vim's previewer for previews by default
set -x FZF_DEFAULT_OPTS "--preview 'preview {}'"
fish_add_path /usr/local/sbin

# set up zoxide
zoxide init fish | source

# Added by Antigravity
fish_add_path /Users/joe/.antigravity/antigravity/bin

# Added by Windsurf
fish_add_path /Users/joe/.codeium/windsurf/bin

# Add completion for targ (disabled due to slow startup)
# TODO: Re-enable when targ is fixed
# if command -q targ
#     targ --completion 2>/dev/null | source
# end

# Mark fish as initialized (enables PWD change hook)
set -g __fish_initialized 1

# Source the PWD hook and restore last directory (after PATH is set up)
if status --is-interactive
    source ~/dotfiles/.config/fish/functions/__pws_on_pwd_change.fish

    # Restore last directory (suppress hook during initial cd)
    set -g __fish_startup 1
    if test -d "$last_dir"
        cd $last_dir
    else
        set -U last_dir $HOME
        cd $HOME
    end
    set -e __fish_startup

    # Show initial status
    clear
    pws
end
