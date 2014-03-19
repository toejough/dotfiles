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
    elif command -v readlink > /dev/null 2>&1; then
        readlink -f $1
    else
        CDPATH="" builtin cd $1 && pwd
    fi
}
