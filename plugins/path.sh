#  Set up various path-related things.

#  make bash use absolute paths!
set -P
#  My utility paths...
utils_bin=~/tools/bin
utils_lib=~/tools/lib
#  Update the bin path
if [ -d $utils_bin ]; then PATH=$utils_bin:$PATH; fi
#  Update the python path
if [ -d $utils_lib ]; then PATH=$utils_lib:$PYTHONPATH; fi
#  Export them
export PATH
export PYTHONPATH
export ORIGINAL_PATH=$PATH
export ORIGINAL_PYTHONPATH=$PYTHONPATH
