# pushd


alias opushd='builtin pushd'
# replace pushd with a version that only keeps the latest entry for each directory,
#  and keeps a global reference to the last directory we went to, across all shells.
function pushd () {
    # perform the push
    builtin pushd "$@"
    # figure out what's at the top of the stack now
    local zero=$(dirs -v | head -1 | awk '{print $2}')
    # if there's an entry for this directory elswhere in the stack...
    if [[ $(dirs -v | tail -n +2 | grep -e '[[:space:]]\+[[:digit:]]\+[[:space:]]\+'"$zero"'$') ]]; then
        # get the oldest matching index
        local index=$(dirs -v | tail -n +2 | grep -e '[[:space:]]\+[[:digit:]]\+[[:space:]]\+'"$zero"'$' | awk '{print $1}' | sed '$!d')
        # rotate to it
        builtin pushd +$index
        # pop it off
        popd
        # rotate back
        local new_index=''
        let new_index=$index-1
        builtin pushd -$new_index
    fi
    # store the top of stack entry to a global location
    lastdir=$(eval echo $zero)
    echo $lastdir | grep '.virtualenvs' > /dev/null 2>&1
    found=$?
    if [ $found -ne 0 ]; then
        echo $lastdir > ~/.lastdir
    fi
}
