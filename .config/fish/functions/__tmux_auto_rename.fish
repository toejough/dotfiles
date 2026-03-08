function __tmux_auto_rename --description "Rename tmux window to repo name or directory basename"
    set -q TMUX; or return

    # Respect manual pin: `tmux set-option -w @pinned-name 1` to stop auto-renaming
    set -l pinned (tmux show-window-option -v @pinned-name 2>/dev/null)
    test "$pinned" = "1"; and return

    set -l name ""
    set -l repo (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$repo"
        set name (basename $repo)
    else
        set name (basename $PWD)
    end

    # Store name on the pane (used by pane-focus-in hook)
    tmux set-option -p @pane-name "$name" 2>/dev/null
    tmux set-option -w automatic-rename off 2>/dev/null
    tmux rename-window "$name"
end
