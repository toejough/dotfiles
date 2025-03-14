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

# Update path to include local ruby
set -x PATH /usr/local/opt/ruby/bin:$PATH
set -x PATH /usr/local/lib/ruby/gems/3.3.0/bin:$PATH

# add a java home for android dev
set -x JAVA_HOME "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
set -x ANDROID_HOME "~/Library/Android/sdk"
set -x ANDROID_SDK_ROOT "~/Library/Android/sdk"
set -x PATH $PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools

# Update path to include brew binaries, first for Apple silicon, second backup for intel.
if test -e /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else
    eval (/usr/local/bin/brew shellenv)
end

dedup PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc' ]; . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'; end

# Set bat/delta theme to solarized dark by default
set -x BAT_THEME "Solarized (dark)"

# Tell FZF to use fzf.vim's previewer for previews by default
set -x FZF_DEFAULT_OPTS "--preview 'preview {}'"
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# set up zoxide
zoxide init fish | source
