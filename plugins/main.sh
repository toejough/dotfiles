# main plugin script
# track the installed plugins and provide plugin API


# [ Globals ]
installed_plugins=""

function plugins-reload() {
    installed_plugins="$plugin_dir/main.sh"
    log-rc "Loading plugins:"
    for plugin in $plugin_dir/*; do
        plugin-load "$plugin"
    done
    log-rc "Done loading plugins."
    log-rc "========================"
}

function plugin-load() {
    local plugin=$1
    local plugin_name=$(basename "$plugin")
    local plugin_path=$plugin
    # check if no path was actually specified, and then assume the plugins dir
    if [[ $(dirname "$plugin") == '.' ]]; then
        plugin_path=$plugin_dir/$plugin
    fi
    # do check for plugin in a subshell so it doesn't print
    local result=$(echo "$installed_plugins" | grep "$plugin_name")
    if [[ -n "$result" ]]; then
        log-rc "  skipping $plugin (already installed)..."
    else
        log-rc "  loading ${plugin_path}..."
        if [ -f "$plugin_path" ]; then
            source "$plugin_path"
            installed_plugins=$installed_plugins" $plugin_name"
        elif [ -d "$plugin_path" ]; then
            if [ -f "$plugin_path"/main.sh ]; then
                source "$plugin_path"/main.sh
                installed_plugins=$installed_plugins" $plugin_name"
            else
                log-rc "  skipping directory plugin ($plugin_path) (missing 'main.sh')..."
            fi
        else
            log-rc "  skipping non-file, non-directory plugin ($plugin_path)..."
        fi
    fi
}
