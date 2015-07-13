# cd


alias ocd='builtin cd'
# automatically cd if command is the name of a directory
# !! Don't - this calls builtin cd no matter what, breaking
# !! the cd awesomeness below...
shopt -u autocd
# replace cd with a version that:
# - shows the directory stack with '?'
# - goes to the last global directory with '!'
# - otherwise moves like cd
# - pushes everything to the stack with pushd
function cdn () {
    # show dir stack
    if [[ "$@" == "?" ]]; then
        dirs -v
    # go to global lastdir if it exists
    elif [[ "$@" == "!" ]]; then
        if [[ ! -f ~/.lastdir ]]; then
            echo 'No lastdir found!' >&2
            return 1
        fi
        local last_dir=$(cat ~/.lastdir)
        if [[ $last_dir ]]; then
            pushd "$last_dir" > /dev/null
        else
            echo 'No lastdir found!' >&2
            return 1
        fi
    # go back a dir
    elif [[ "$@" == "-" ]]; then
        popd > /dev/null
        pushd +0 > /dev/null
    # go home
    elif [[ $# -eq 0 ]]; then
        pushd ~ > /dev/null
    # pushd
    else
        pushd "$@" > /dev/null
    fi
}

# cd and here
# requires ls.sh
plugins-load 'ls.sh'
function cd () {
    cdn "$@" && here
}
