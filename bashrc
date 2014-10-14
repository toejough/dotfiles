# [ Wishlist ]
# - dedup history on shell exit
# - a real 'bottom' func that goes to the lowest dir
# - ask to create dirlinks with a link to this dir
# - ask to create a tools bin/lib
# - only change editor to vim if vim exists
# - try echo -e to set colors in the functions
# - functionalize things so that we don't leak env vars
# - ask to create aliases when a command is not found and shows up multiple times in the list
# - ask to create files/directories the config expects

#  [ Clean Slate ]
# clear all aliases
\unalias -a

# [ Bootstrap Defs ]
export rc_dir=$(cd $(dirname $BASH_SOURCE) && pwd)
export rc_log=$rc_dir/log
post_rc_commands=' : '

# [ Logging ]
function log-rc() {
    echo "$@" | tee -a $rc_log;
}

# [ TTY startup ]
# Announce OS (I regularly log into machines with different OS's)
log-rc "========================"
log-rc "[ OS: $(uname) ]"
log-rc "========================"

# [ Plugins ]
export plugin_dir=$rc_dir/plugins
if [ -d $plugin_dir -a -f $plugin_dir/main.sh ]; then
    source $plugin_dir/main.sh
fi
# [ -TMUX- ]
# launch tmux all the time - the session persistence and status bar
# are really nice
plugin-load tmux.sh && log-rc "------------------------" && tmux-launch
# [ -Other Plugins- ]
# if we got past tmux-launch, load the remaining plugins and continue
plugins-reload

# [ Path Cleanup ]
# Start with a clean, deduplicated set of paths
export PATH=$(pathdd $PATH)
export PYTHONPATH=$(pathdd $PYTHONPATH)
