#!/bin/bash
# Hook: save content hash when switching windows
# Marks both the window we left and entered as "read"
# Hash via variable to match activity.sh (bash strips trailing newlines)

sleep 0.3  # Let focus-event output settle before snapshotting

# Save hash for the window we just left
last_pane=$(tmux display-message -t '{last}' -p '#{pane_id}' 2>/dev/null)
if [ -n "$last_pane" ]; then
    content=$(tmux capture-pane -t "$last_pane" -p 2>/dev/null | awk '{a[NR]=$0} END{for(i=1;i<=NR-1;i++)print a[i]}')
    printf '%s\n' "$content" | md5 > "/tmp/tmux-seen-${last_pane//[%.]/-}"
    tmux set-option -wuqt "$last_pane" @content-changed 2>/dev/null
fi

# Save hash for the window we just entered
pane_id=$(tmux display-message -p '#{pane_id}')
content=$(tmux capture-pane -t "$pane_id" -p 2>/dev/null | awk '{a[NR]=$0} END{for(i=1;i<=NR-1;i++)print a[i]}')
printf '%s\n' "$content" | md5 > "/tmp/tmux-seen-${pane_id//[%.]/-}"
tmux set-option -wuq @content-changed 2>/dev/null
