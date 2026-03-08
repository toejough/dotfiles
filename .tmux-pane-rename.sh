#!/bin/bash
# Rename tmux window to the active pane's @pane-name (set by fish on cd)
n=$(tmux show-option -pqv @pane-name)
p=$(tmux show-window-option -qv @pinned-name)
if [ -n "$n" ] && [ "$p" != 1 ]; then
    tmux rename-window "$n"
fi
