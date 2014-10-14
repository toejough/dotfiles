
installed_plugins=""

function plugins-reload() {
    installed_plugins="$plugin_dir/main.sh"
    log-rc "Loading plugins:"
    for plugin in $plugin_dir/*; do
        plugin-load $plugin
    done
    log-rc "Done loading plugins."
    log-rc "------------------------"
}

function plugin-load() {
    plugin=$1
    if [[ $(dirname $plugin) == '.' ]]; then
        plugin=$plugin_dir/$plugin
    fi
    if [[ -z $(grep $plugin <<<$installed_plugins) ]]; then
        log-rc "  loading ${plugin}..."
        if [ -f $plugin ]; then
            source $plugin
            installed_plugins=$installed_plugins" $(basename $plugin)"
        elif [ -d $plugin -a -f $plugin/main.sh ]; then
            source $plugin/main.sh
            installed_plugins=$installed_plugins" $(basename $plugin)"
        fi
    fi
}
