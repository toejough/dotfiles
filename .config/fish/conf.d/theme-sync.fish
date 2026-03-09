# Sync terminal colors with macOS light/dark appearance on each prompt
status is-interactive; or exit
function __sync_theme_hook --on-event fish_prompt
    __sync_theme
end
