#!/bin/bash
# Activity sparkline (screen changes) + content change detection for tmux windows
# Called from window-status-format via #() every status-interval

pane_tty=${1#/dev/}
pane_id=$2
window_active=$3
[ -z "$pane_id" ] && exit 0

# Use window index as the sparkline key (aggregates all panes)
window_idx=$(tmux display-message -t "$pane_id" -p '#{window_index}' 2>/dev/null)
[ -z "$window_idx" ] && exit 0

spark_state="/tmp/tmux-spark-w${window_idx}"

# --- Sparkline: max change across all panes in the window ---
max_change=0

for pid in $(tmux list-panes -t ":${window_idx}" -F '#{pane_id}' 2>/dev/null); do
    prev_content="/tmp/tmux-spark-content-${pid//[%.]/-}"

    content=$(tmux capture-pane -t "$pid" -p 2>/dev/null | awk '{a[NR]=$0} END{for(i=1;i<=NR-1;i++)print a[i]}')

    change_pct=0
    if [ -f "$prev_content" ]; then
        total=$(printf '%s\n' "$content" | wc -l | tr -d ' ')
        if [ "$total" -gt 0 ]; then
            changed=$(diff <(printf '%s\n' "$content") "$prev_content" 2>/dev/null | grep -c '^[<>]')
            change_pct=$((changed * 50 / total))
            [ "$change_pct" -gt 100 ] && change_pct=100
        fi
    fi
    printf '%s\n' "$content" > "$prev_content"

    [ "$change_pct" -gt "$max_change" ] && max_change=$change_pct
done

# Update readings
readings=()
[ -f "$spark_state" ] && while read -r val; do readings+=("$val"); done < "$spark_state"

all_idle=true
for val in "${readings[@]}" "$max_change"; do
    [ "$val" -gt 0 ] 2>/dev/null && { all_idle=false; break; }
done

if $all_idle && [ ${#readings[@]} -gt 0 ]; then
    readings=("${readings[@]:1}")
elif ! $all_idle; then
    readings+=("$max_change")
    while [ ${#readings[@]} -gt 5 ]; do readings=("${readings[@]:1}"); done
fi

printf '%s\n' "${readings[@]}" > "$spark_state"

if [ ${#readings[@]} -gt 0 ]; then
    printf ':'
    for val in "${readings[@]}"; do
        if   [ "$val" -le 0 ];  then printf '▁'
        elif [ "$val" -le 5 ];  then printf '▂'
        elif [ "$val" -le 15 ]; then printf '▃'
        elif [ "$val" -le 25 ]; then printf '▄'
        elif [ "$val" -le 40 ]; then printf '▅'
        elif [ "$val" -le 60 ]; then printf '▆'
        elif [ "$val" -le 80 ]; then printf '▇'
        else                         printf '█'
        fi
    done
    printf ':'
else
    printf ':'
fi

# --- Content change detection (yellow ! indicator) ---
# Only checks the active pane (the one tmux passed us)
if [ -n "$pane_id" ]; then
    seen_state="/tmp/tmux-seen-${pane_id//[%.]/-}"
    content=$(tmux capture-pane -t "$pane_id" -p 2>/dev/null | awk '{a[NR]=$0} END{for(i=1;i<=NR-1;i++)print a[i]}')
    current_hash=$(printf '%s\n' "$content" | md5)
    if [ "$window_active" = "1" ]; then
        tmux set-option -wuqt "$pane_id" @content-changed 2>/dev/null
    elif [ ! -f "$seen_state" ]; then
        tmux set-option -wqt "$pane_id" @content-changed 1 2>/dev/null
    else
        saved=$(cat "$seen_state")
        if [ "$current_hash" != "$saved" ]; then
            tmux set-option -wqt "$pane_id" @content-changed 1 2>/dev/null
        else
            tmux set-option -wuqt "$pane_id" @content-changed 2>/dev/null
        fi
    fi
fi
