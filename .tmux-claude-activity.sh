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
    while [ ${#readings[@]} -gt 10 ]; do readings=("${readings[@]:1}"); done
fi

printf '%s\n' "${readings[@]}" > "$spark_state"

# Map value to braille height (0-4)
bh() {
    local v=$1
    if   [ "$v" -le 0 ];  then echo 0
    elif [ "$v" -le 10 ]; then echo 1
    elif [ "$v" -le 30 ]; then echo 2
    elif [ "$v" -le 60 ]; then echo 3
    else                       echo 4
    fi
}

if [ ${#readings[@]} -gt 0 ]; then
    # Pad to even count at the left so newest pairs stay stable
    (( ${#readings[@]} % 2 == 1 )) && readings=(0 "${readings[@]}")

    # Braille lookup: each char encodes two values (left col, right col)
    # Index: left*5 + right, where left/right are heights 0-4
    braille=(
        '⠀' '⢀' '⢠' '⢰' '⢸'
        '⡀' '⣀' '⣠' '⣰' '⣸'
        '⡄' '⣄' '⣤' '⣴' '⣼'
        '⡆' '⣆' '⣦' '⣶' '⣾'
        '⡇' '⣇' '⣧' '⣷' '⣿'
    )

    printf ':'
    for ((i=0; i<${#readings[@]}; i+=2)); do
        l=$(bh "${readings[i]}")
        r=$(bh "${readings[i+1]}")
        printf '%s' "${braille[l*5+r]}"
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
