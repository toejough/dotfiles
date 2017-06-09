#  Modifications to bash history functionality

#  append to history instead of replacing history on shell exit
shopt -s histappend
#  unlimited history
export HISTSIZE=-1
export HISTFILESIZE=-1
if bash --version | grep 'version 4.3' > /dev/null 2>&1; then
    export HISTSIZE=-1
    export HISTFILESIZE=-1
fi

#  keep only the latest copy of a command
export HISTCONTROL='erasedups'
#  add timestamps
export HISTTIMEFORMAT=': %H:%M:%S %m/%d/%Y; '
#  History manipulations
#  Push the local history items ordered after the last matching global history item
#    to the global history.  Appends to end of global history.
alias history_push='history -a'
#  Clears local history
alias history_clear='history -c'
#  Pull the global history items.  Appends to end of local history.
alias history_pull='history -r'
#  Dedup global history manually since the 'erasedups' only works on local history.
hist_dedup_script=$PLUGINS_DIR/history/history_dedup.py
if [ -f $hist_dedup_script -a -n "$(command -v python)" ]; then
    alias history_dedup='python $hist_dedup_script ~/.bash_history'
fi
#  Sort global history manually since it doesn't do that for us.
hist_sort_script=$PLUGINS_DIR/history/history_sort.py
if [ -f $hist_sort_script -a -n "$(command -v python)" ]; then
    alias history_sort='python $hist_sort_script ~/.bash_history'
fi
#  Add post commands - running them now makes bash history wonky
#  check on history
post_rc_commands="$post_rc_commands; python $PLUGINS_DIR/history/history_verify.py"
#  Sort the global history if possible
if [ -n "$(command -v history_sort)" ]; then
    post_rc_commands="$post_rc_commands; history_sort"
fi
#  Dedup history if possible
if [ -n "$(command -v history_dedup)" ]; then
    post_rc_commands="$post_rc_commands; history_dedup"
fi
#  back up history
post_rc_commands="$post_rc_commands; cp ~/.bash_history ~/.bash_history.old"
#  Clear and re-load
post_rc_commands="$post_rc_commands; history_clear; history_pull"
