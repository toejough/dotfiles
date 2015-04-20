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
# Announce Host & OS (I regularly log into different machines with different OS's)
log-rc "========================"
log-rc "[ Host: $(hostname -s) ]"
log-rc "[ OS: $(uname) ]"
log-rc "========================"


# [ Plugins ]
export PLUGINS_DIR=$rc_dir/plugins
if [ -d "$PLUGINS_DIR" -a -f "$PLUGINS_DIR"/main.sh ]; then
    source "$PLUGINS_DIR"/main.sh
fi


# [ -TMUX- ]
# launch tmux all the time - the session persistence and status bar
# are really nice
log-rc "[ TMUX ]"
plugins-load tmux.sh && log-rc "------------------------" && tmux-launch && log-rc "========================"


# [ -Other Plugins- ]
# if we got past tmux-launch, load the remaining plugins and continue
log-rc "[ Plugins ]"
plugins-load
log-rc "========================"


# [ Path Cleanup ]
# Start with a clean, deduplicated set of paths
export PATH=$(pathdd "$PATH")
export PYTHONPATH=$(pathdd "$PYTHONPATH")


# [ Exec ]
# Run an environment var
if [[ -n "$STARTUP_COMMAND" ]]; then
    log-rc "[ Startup Command ]"
    log-rc "------------------------"
    eval $STARTUP_COMMAND
    log-rc "========================"
fi
