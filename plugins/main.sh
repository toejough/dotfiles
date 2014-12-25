# main plugin script
# track the installed plugins and provide plugin API


# [ Globals ]
INSTALLED_PLUGINS="main.sh"


# [ API ]
function plugins() {
    # Top-level plugin command
    # parse args
    local args="list"  # default to the 'list' command
    if [[ $# != 0 ]]; then
        args=$@
    fi
    plugins-dispatch plugins $args
}


function plugins-dispatch() {
    # Dispatch 'x y z' commands to x-y-z functions
    local prefix=$1; shift
    if [[ $# == 0 ]]; then
        # no more parts to the potential command, and was not
        # found on the previous try...
        printf "ERROR: No such 'plugins' command (%s)" "$prefix"
        return 1
    fi
    # try to form a new command
    local command="$prefix-$1"; shift
    local output=$(command -V $command);  # find the command
    # did we find it?
    local rc=$?
    if [[ $rc != 0 ]]; then
        # if not, try the next level in the command
        plugins-dispatch $command $@
    else
        # if so, execute it!
        $command $@
    fi
}


function plugins-list() {
    # List the installed plugins
    printf "\nInstalled plugins:\n"
    for plugin in $INSTALLED_PLUGINS; do
        printf "... %s\n" "$plugin"
    done
    printf "\n"
}


function plugins-load() {
    # Load plugins - either the ones listed, or all
    # parse args
    local method="single"
    if [[ $# > 1 ]]; then
        method="list"
    elif [[ $# == 0 ]]; then
        method="all"
    fi
    # run command
    plugins-explicit-load-$method $@
}


function plugins-explicit-load-single() {
    # Explicitly load a single plugin
    local plugin=$1
    local plugin_name=$(basename "$plugin")
    local plugin_path=$plugin
    # check if no path was actually specified, and then assume the plugins dir
    if [[ $(dirname "$plugin") == '.' ]]; then
        plugin_path=$PLUGINS_DIR/$plugin
    fi
    # do check for plugin in a subshell so it doesn't print
    local result=$(echo "$INSTALLED_PLUGINS" | grep "$plugin_name")
    if [[ -n "$result" ]]; then
        log-rc "  skipping $plugin (already installed)..."
    else
        log-rc "  loading ${plugin_path}..."
        if [ -f "$plugin_path" ]; then
            source "$plugin_path"
            INSTALLED_PLUGINS=$INSTALLED_PLUGINS" $plugin_name"
        elif [ -d "$plugin_path" ]; then
            if [ -f "$plugin_path"/main.sh ]; then
                source "$plugin_path"/main.sh
                INSTALLED_PLUGINS=$INSTALLED_PLUGINS" $plugin_name"
            else
                log-rc "  skipping directory plugin ($plugin_path) (missing 'main.sh')..."
            fi
        else
            log-rc "  skipping non-file, non-directory plugin ($plugin_path)..."
        fi
    fi
}


function plugins-explicit-load-list() {
    # explicitly load the given list of plugins
    for plugin in $@; do
        plugins-explicit-load-single "$plugin"
        local rc=$?
        if [[ $rc != 0 ]]; then
            return $rc
        fi
    done
}


function plugins-explicit-load-all() {
    # explicitly load all discovered plugins
    plugins-explicit-load-list "$PLUGINS_DIR"/*
}
