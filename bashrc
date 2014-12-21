# bashrc
# set up for an interactive bash shell


# [ Clean Slate ]
# clear all aliases
\unalias -a


# [ Bootstrap Defs ]
source_directory=$(dirname "$BASH_SOURCE")
export rc_dir=$(cd "$source_directory" && pwd)
export rc_log=$rc_dir/log
export post_rc_commands=' : '


# [ Logging ]
function log-rc() {
    echo "$@" | tee -a "$rc_log";
}


# [ TTY startup ]
# Announce OS (I regularly log into machines with different OS's)
log-rc "========================"
log-rc "[ OS: $(uname) ]"
log-rc "[ Host: $(hostname -s) ]"
log-rc "========================"


# [ Plugins ]
export plugin_dir=$rc_dir/plugins
if [ -d "$plugin_dir" -a -f "$plugin_dir"/main.sh ]; then
    source "$plugin_dir"/main.sh
fi


# [ -TMUX- ]
# launch tmux all the time - the session persistence and status bar
# are really nice
log-rc "[ TMUX ]"
plugin-load tmux.sh && log-rc "------------------------" && tmux-launch && log-rc "========================"


# [ -Other Plugins- ]
# if we got past tmux-launch, load the remaining plugins and continue
log-rc "[ Plugins ]"
plugins-reload


# [ Path Cleanup ]
# Start with a clean, deduplicated set of paths
export PATH=$(pathdd "$PATH")
export PYTHONPATH=$(pathdd "$PYTHONPATH")
