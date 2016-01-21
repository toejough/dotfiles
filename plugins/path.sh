#  Set up various path-related things.


#  make bash use absolute paths!
set -P
#  My utility paths...
utils_bin=~/tools/bin
utils_lib=~/tools/lib
#  Update the bin path
if [ -d $utils_bin ]; then PATH=$utils_bin:$PATH; fi
#  Update the python path
if [ -d $utils_lib ]; then PYTHONPATH=$utils_lib:$PYTHONPATH; fi
#  Export them
export PATH=$PATH
export PYTHONPATH=$PYTHONPATH
export ORIGINAL_PATH=$PATH
export ORIGINAL_PYTHONPATH=$PYTHONPATH
#  Env-agnostic full path function
function fullpath () {
    if [ $# -ne 1 ]; then
        echo "fullpath takes exactly one arg!" 1>&2
        exit 1
    elif command -v realpath > /dev/null 2>&1; then
        realpath $1
    else
        CDPATH="" builtin cd $(dirname "$1") && echo $(pwd)"/"$(basename "$1")
    fi
}

#path deduplication
function pathdd () {
    python -c 'x=[]; y=[x.append(p) for p in "'"$1"'".split(":") if p not in x]; print ":".join(x)'
}
# path reduction
alias condense_paths="sed 's/\/.*\(\/.*\..*\)/\/..\1/g'"
#  add to path
function __add_to_path() {
    if [[ $# -eq 0 ]]; then
        local path_to_add=./
    else
        local path_to_add="$1"
    fi
    path_to_add=$(fullpath "$path_to_add")
    export PATH=$(pathdd "$path_to_add:$PATH")
    echo PATH="$PATH"
}
function __add_to_python_path() {
    if [[ $# -eq 0 ]]; then
        local path_to_add=./
    else
        local path_to_add=$1
    fi
    path_to_add=$(fullpath $path_to_add)
    export PYTHONPATH=$(pathdd $path_to_add:$PYTHONPATH)
    echo PYTHONPATH=$PYTHONPATH
}
function __reset_path () {
    export PATH=$ORIGINAL_PATH
    echo PATH=$PATH
}
function __reset_python_path () {
    export PYTHONPATH=$ORIGINAL_PYTHONPATH
    echo PYTHONPATH=$PYTHONPATH
}
function paths () {
    echo PATH=$PATH
    echo PYTHONPATH=$PYTHONPATH
}
function addtopath () {
    if [[ "$1" == "-e" ]]; then
        shift
        __add_to_path "$1"
    elif [[ "$1" == "-p" ]]; then
        shift
        __add_to_python_path $1
    else
        __add_to_path "$1"
        __add_to_python_path $1
    fi
}
function resetpath () {
    if [[ "$1" == "-e" ]]; then
        __reset_path
    elif [[ "$1" == "-p" ]]; then
        __reset_python_path
    else
        __reset_path
        __reset_python_path
    fi
}
