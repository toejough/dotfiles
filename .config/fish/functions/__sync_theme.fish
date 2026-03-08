function __sync_theme --description "Sync terminal theme with macOS appearance"
    # Only run in interactive sessions
    if not status is-interactive
        return
    end

    # Detect macOS appearance ("Dark" on dark mode, fails on light)
    set -l appearance dark
    if not defaults read -g AppleInterfaceStyle &>/dev/null
        set appearance light
    end

    # Skip if unchanged
    if test "$__current_appearance" = "$appearance"
        return
    end
    set -g __current_appearance $appearance

    # Solarized palette reference:
    #   base03  #002b36  (dark bg)     base3   #fdf6e3  (light bg)
    #   base02  #073642  (dark hl)     base2   #eee8d5  (light hl/status bg)
    #   base01  #586e75  (dark comment) base1   #93a1a1  (light comment)
    #   base00  #657b83  (light text)  base0   #839496  (dark text)
    #   green   #859900

    # Update bat/delta theme
    if test "$appearance" = dark
        set -gx BAT_THEME "Solarized (dark)"
    else
        set -gx BAT_THEME "Solarized (light)"
    end

    # Tmux status bar is synced via client-focus-in hook (~/.tmux-theme-sync.sh)
end
