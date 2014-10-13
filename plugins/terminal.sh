# terminal functions


#type: 0 - both, 1 - tab, 2 - title
function setTerminalText () {
    local mode=$1; shift
    echo -ne "\033]$mode;$@\007"
}
function set_tt () { setTerminalText 0 $@; }
function set_tab () { setTerminalText 1 $@; }
function set_title () { setTerminalText 2 $@; }
