#  Use CDPATH to make it easy to mark the current dir
#    with a name that you can cd to from any other location.

#  Directory for the shortcuts...
shortcuts=~/.dirlinks
#  Update the cd path
if [ -d $shortcuts ]; then
    CDPATH=.:$shortcuts
    function mark ()
    {
        NAME=$1
        ln -siwv -s $(pwd) $shortcuts/$NAME
    }
    function unmark ()
    {
        NAME=$1
        rm $shortcuts/$NAME
    }
    function marks ()
    {
        ls -l $shortcuts | awk '{print $9, $10, $11}' && echo
    }
fi
#  Export it
export CDPATH=$CDPATH
