# Plan: fix tmux $TERM

## Problem
`:checkhealth vim.health` reports `$TERM should be "screen-256color", "tmux-256color", or "tmux-direct" in tmux. Colors might look wrong.`

Current `~/.tmux.conf` line 4:
```
set -g default-terminal "$TERM"
```
This inherits the outer terminal's TERM (`xterm-ghostty`) and exposes it to programs running inside tmux. nvim and others expect a tmux-aware TERM there.

## Change
File: `~/.tmux.conf` (symlink to `/Users/joe/dotfiles/.tmux.conf`).

Replace lines 3–6:
```
set-option -g default-shell /opt/homebrew/bin/fish
set -g default-terminal "$TERM"
# from https://medium.com/...
set -ga terminal-overrides ",$TERM:Tc"
```
with:
```
set-option -g default-shell /opt/homebrew/bin/fish
# expose tmux-256color to programs inside tmux (nvim, etc.)
set -g default-terminal "tmux-256color"
# allow truecolor passthrough from the outer terminal (ghostty)
set -ga terminal-overrides ",xterm-ghostty:Tc"
```

Keep the undercurl line as-is — it's parametrized over `*` not `$TERM`.

## Verification
- Pre: `tmux display-message -p '#{client_termname}'` returns `xterm-ghostty`.
- Reload current sessions: `tmux source-file ~/.tmux.conf`.
- New panes/sessions only: opening a fresh pane shows `echo $TERM` = `tmux-256color`. Existing panes keep their old TERM until restarted (this is a tmux limitation, not a config bug).
- Post: `nvim --headless "+checkhealth vim.health" "+qa!"` inside a fresh pane shows no `$TERM should be ...` ERROR.

## Risk
- Hot-reloading via `source-file` only affects new panes' TERM. To fully apply, Joe needs to either open new panes for his current work or restart the tmux server (`tmux kill-server` followed by re-attach — destroys all current sessions).
- The Ghostty truecolor flag stays in place via the explicit `xterm-ghostty:Tc` line, so colors won't degrade.
