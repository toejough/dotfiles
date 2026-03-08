#!/bin/bash
# Sync tmux status bar colors with macOS light/dark appearance
if defaults read -g AppleInterfaceStyle &>/dev/null; then
    # Dark mode
    tmux set -g status-bg '#002b36'
    tmux set -g status-fg '#839496'
    tmux set -g window-status-current-format \
        '[#{?#{@agent-color},#[fg=#{@agent-color}],#[fg=#eee8d5]}#[bold]#I#(~/.tmux-claude-activity.sh #{pane_tty} #{pane_id} 1)#W#F#[default]]'
    tmux set -g 'status-format[1]' \
        '#[align=left,fg=#859900,bold]#S:#I.#P #[align=right,fg=#eee8d5,bold]%I:%M %p #[fg=#859900,nobold][%a, %D]'
else
    # Light mode
    tmux set -g status-bg '#eee8d5'
    tmux set -g status-fg '#657b83'
    tmux set -g window-status-current-format \
        '[#{?#{@agent-color},#[fg=#{@agent-color}],#[fg=#073642]}#[bold]#I#(~/.tmux-claude-activity.sh #{pane_tty} #{pane_id} 1)#W#F#[default]]'
    tmux set -g 'status-format[1]' \
        '#[align=left,fg=#859900,bold]#S:#I.#P #[align=right,fg=#073642,bold]%I:%M %p #[fg=#859900,nobold][%a, %D]'
fi
