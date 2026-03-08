function __pws_on_pwd_change --on-variable PWD --description "Show status on directory change"
    # Skip during startup (config.fish handles that)
    if not set -q __fish_initialized; or set -q __fish_startup
        return
    end

    # Update last_dir for session persistence
    set -U last_dir $PWD

    # Update tmux window name
    __tmux_auto_rename

    # Show status
    pws
end
