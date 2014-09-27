
installed_plugins=""

function plugins-load-new() {
    log-rc "========================"
    log-rc "Loading plugins:"
    for plugin in $plugin_dir/*; do
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
    done
    log-rc "Done loading plugins."
}

function plugins-reload() {
    installed_plugins="$plugin_dir/main.sh"
    plugins-load-new
}

plugins-reload
