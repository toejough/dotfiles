#!/bin/bash
# Rename tmux window to active pane's repo or directory name on pane focus
# Skip agent windows (they have @agent-color set by tmux-claude-pane.sh)
agent=$(tmux show -wqv @agent-color 2>/dev/null)
[ -n "$agent" ] && exit 0

dir=$(tmux display-message -p '#{pane_current_path}')
repo=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$repo" ]; then
    n=$(basename "$repo")
else
    n=$(basename "$dir")
fi

tmux set-option -p @pane-name "$n" 2>/dev/null
tmux rename-window "$n"
