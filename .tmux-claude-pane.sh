#!/bin/bash
# tmux hook script: detect claude agent panes and break them into their own windows
# Called by after-split-window hook. Scans twice to catch late-starting processes.

scan_and_break() {
    tmux list-panes -s -F '#{pane_id} #{pane_index} #{pane_tty} #{window_panes} #{window_name}' | while read -r pane_id pane_index pane_tty window_panes window_name; do
        # Already in its own window
        [ "$window_panes" -le 1 ] && continue
        # Don't touch the main pane
        [ "$pane_index" = "0" ] && continue

        # Check ALL processes on this pane's tty for the claude agent pattern
        tty=${pane_tty#/dev/}
        cmd=$(ps -ww -t "$tty" -o args= 2>/dev/null | grep -- '--team-name' | head -1)
        [ -z "$cmd" ] && continue

        agent=$(printf '%s' "$cmd" | awk -F'--agent-name ' '{print $2}' | awk '{print $1}')
        color=$(printf '%s' "$cmd" | awk -F'--agent-color ' '{print $2}' | awk '{print $1}')
        if [ -n "$agent" ]; then
            new=$(tmux break-pane -dP -F '#{window_id}' -s "$pane_id" -n "$window_name:$agent")
            tmux set-option -wt "$new" automatic-rename off 2>/dev/null
            [ -n "$color" ] && tmux set-option -wt "$new" @agent-color "$color" 2>/dev/null
        fi
    done
}

sleep 1
scan_and_break
# Retry after longer delay to catch processes that were still starting
sleep 4
scan_and_break
