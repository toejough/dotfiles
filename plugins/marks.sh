#  Use CDPATH to make it easy to mark the current dir
#    with a name that you can cd to from any other location.

#  Directory for the shortcuts...
shortcuts=~/links
#  Update the cd path
if [ -d $shortcuts ]; then
    function mark ()
    {
        NAME=$1
        ln -siv $(pwd) $shortcuts/$NAME
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
    # requires cd.sh
    plugins-load 'cd.sh'
    function jump() {
        ocd ~
        cdh $shortcuts/$1
    }
fi
