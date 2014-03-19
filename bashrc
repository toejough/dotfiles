# [ Wishlist ]
# - dedup history on shell exit
# - a real 'bottom' func that goes to the lowest dir
# - ask to create dirlinks with a link to this dir
# - ask to create a tools bin/lib
# - only change editor to vim if vim exists
# - try echo -e to set colors in the functions
# - functionalize things so that we don't leak env vars
# - ask to create aliases when a command is not found and shows up multiple times in the list
# - ask to create files/directories the config expects

#  [ Clean Slate ]
# clear all aliases
\unalias -a

#  [ Plugins ]
export joe_rc_dir=$(cd $(dirname $BASH_SOURCE) && pwd)
export joe_plugin_dir=$joe_rc_dir/plugins
post_rc_commands=' : '
for plugin in $joe_plugin_dir/*; do
    if [ -f $plugin ]; then
        source $plugin
    elif [ -d $plugin -a -f $plugin/main.sh ]; then
        source $plugin/main.sh
    fi
done

# [ One-liners ]
export EDITOR=vim
export PAGER=less
export LANG=en_US.UTF-8

# [ Prompts ]
# prompt strings undergo variable expansion after prompt expansion
shopt -s promptvars
# [ -Colors- ]
DEFAULT='\[\e[0;39m\]'
WHITE='\[\e[0;37m\]'
BOLD_WHITE='\[\e[1;37m\]'
GREEN='\[\e[0;32m\]'
RED='\[\e[0;31m\]'
YELLOW='\[\e[0;33m\]'
ORANGE='\[\e[38;5;208m\]'
CYAN='\[\e[0;36m\]'
# [ -Helper Funcs- ]
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
function __orphaned_ps1() {
    if ! fullpath ./ > /dev/null 2>&1; then
        echo "<pwd orphaned!>"
    fi
}
function __rc_ps1 () {
    RC=$1
    if [ $RC -ne 0 ]; then
        echo "[ $RC ]"
    fi
}
function __jobs_ps1 () {
    JOBS=$1
    if [ $JOBS -ne 0 ]; then
        echo "($JOBS)"
    fi
}
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
fi
if [ -z $(command -v __git_ps1) ]; then
    function __git_ps1 { :
    }
fi
function __ssh () {
    if [ -n "$SSH_CONNECTION" ]; then
        echo ""
    fi
}
# [ -Prompt Definitions- ]
# PS1 is main prompt
# Set PS1 to be ssh_lock_symbol[rc][username@host:curdir (git branch)<orphaned>](jobs)$
PS1=\
"$CYAN"'$(__ssh)'\
"$RED"'$(__rc_ps1 $?)'\
"$DEFAULT["\
"$BOLD_WHITE\u"\
"$DEFAULT@\h:\W"\
"$GREEN"'$(__git_ps1)'\
"$ORANGE"'$(__orphaned_ps1)'\
"$DEFAULT]"\
"$YELLOW"'$(__jobs_ps1 '"\j"')'\
"$DEFAULT$ "
# PS2 is line continuation prompt
PS2='>'
# PS3 is 'select' prompt
PS3='<<Choose an option>>'
# PS4 is 'xtrace' prompt - used with set -x for debugging
PS4='>'"$RED"' $LINENO: '"$DEFAULT"

# [ Aliases ]
# use aliases
shopt -s expand_aliases
#make resourcing this file easier
alias resource="source ~/.bash_profile"
#  sort by year, month, date, hour, minute, second
alias lthsort="sort -k 9,9 -k 6,6M -k 7,7 -k 8.1,8.3 -k 8.4,8.6 -k 8.7,8.9"
#  condense paths in strings
alias condense_paths="sed 's/\/.*\(\/.*\..*\)/\/..\1/g'"
#  Show where I am and what's here
if [ "$(uname)" = "Linux" ]; then
    alias here='echo && pwd && echo && ls --full-time -rh && echo'
else
    alias here='echo && pwd && echo && ls -lTrh && echo'
fi
#  Update spf13 vim
alias update-spf13="sh <(curl https://j.mp/spf13-vim3 -L)"
# [ -Mistype Aliases- ]
mistype_aliases_file=~/.mistype.aliases
if [ -e $mistype_aliases_file ]; then
    source $mistype_aliases_file
fi

# [ Built-in Adjustments ]
# [ -ls- ]
#add colors (G) and file recognition (F) and hidden files (A) to ls
alias ols="$(which ls)"
if [ "$(uname)" = "Linux" ]; then
    export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
    alias ls="ols -FGA --color=always"
else
    #fix dark blue color in LS in FreeBSD
    export LSCOLORS=Exfxcxdxbxegedabagacad
    alias ls="ols -FGA"
fi
alias lsl="ls -lha"
# [ -mv- ]
#add prompt before overwrite (i) and verbose output (v) to mv
alias omv="$(which mv)"
alias mv="mv -iv"
# [ -ln- ]
#default to symbolic link (s), prompt before overwrite (i), print verbose
# output (v), [and on FreeBSD warn if the source doesn't exist (w)] for ln
alias oln='$(which ln)'
if [ "$(uname)" = "Linux" ]; then
    alias ln="ln -siv"
elif [ "$(uname)" = "Darwin" ]; then
    alias ln="ln -siv"
else
    alias ln="ln -siwv"
fi
# [ -pushd- ]
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
# [ -cd- ]
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
function cd () {
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
            pushd $last_dir > /dev/null
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

# [ Shell Config ]
#make bash use vi mode!
# esc: normal mode
# esc, v: edit the current line!
# esc, /<text>: search history!
set -o vi
# check for running jobs and warn user before exiting
shopt -s checkjobs
# check and update the window size after every command
shopt -s checkwinsize
# comments in shell
shopt -s interactive_comments
# 'source' uses the path to find files
shopt -s sourcepath
#trap "err_handle" ERR - when a command is not found, store it in the commands_not_found file
not_found_file=~/.commands_not_found
function command_not_found_handle {
    echo "$1" >> $not_found_file;
    echo "Unknown command: $1"
}

# [ Utility Functions ]
# [ -git- ]
function refetch() { git fetch && git rebase -i origin/$1; }
function git-switch() { git checkout $1 && refetch $1; }
# [ -iterm- ]
#type: 0 - both, 1 - tab, 2 - title
function setTerminalText () {
    local mode=$1; shift
    echo -ne "\033]$mode;$@\007"
}
function set_tt () { setTerminalText 0 $@; }
function set_tab () { setTerminalText 1 $@; }
function set_title () { setTerminalText 2 $@; }
# [ -misc- ]
#path reduction
function pathdd () {
    python -c 'x=[]; y=[x.append(p) for p in "'$1'".split(":") if p not in x]; print ":".join(x)'
}
#  add to path
function __add_to_path() {
    if [[ $# -eq 0 ]]; then
        local path_to_add=./
    else
        local path_to_add=$1
    fi
    path_to_add=$(fullpath $path_to_add)
    export PATH=$(pathdd $path_to_add:$PATH)
    echo PATH=$PATH
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
        __add_to_path $1
    elif [[ "$1" == "-p" ]]; then
        shift
        __add_to_python_path $1
    else
        __add_to_path $1
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
# cd and here
function cdh () {
    cd $@ && here
}
# normal math!
function calc {
    awk "BEGIN {print $* }"
}
# what is a command?
function whatis {
    answer=$(command -V $1)
    if [ -n "$answer" ]; then
        echo -e "$answer"
    else
        echo "'$1' not found"
    fi
}
# y/n prompt!
function yes_or_no {
    local default='N'
    local choice=$default
    local prompt="$1? [y/N]: "
    local answer

    while [ 1 ]; do
        read -p "$prompt" -n 1 answer
        [ -z "$answer" ] && answer=$default
        echo '' >&2

        case "$answer" in
            [yY] ) echo 'yes'
                break
                ;;
            [nN] ) echo 'no'
                break
                ;;
            * ) ;;
        esac
    done
}
# fat-finger analysis
function analyze_commands_not_found () {
    if [ -e $not_found_file ]; then
        local unrecognized=$(tail -n 1 $not_found_file);
        local last_command=$(history | tail -n 1 | awk '{ print $5 }');
        if [ "$unrecognized" == "$last_command" ]; then
            local count=$(grep -c "$unrecognized" $not_found_file);
            if [ $count -gt 1 ]; then
                local yn=$(yes_or_no 'This command has been entered before.  Would you like to create an alias?');
                if [ "$yn" == "yes" ]; then
                    local meant_to_type;
                    read -p "Please enter the text you meant to type: " meant_to_type;
                    echo "alias $unrecognized='$meant_to_type'" >> $mistype_aliases_file;
                    echo $(grep -v $unrecognized $not_found_file) > $not_found_file
                    source $mistype_aliases_file
                fi
            fi
        fi
    fi
}
# [ -tmux- ]
exit_file=$HOME/noexit
alias exittmux='[ -z "$TMUX" ] && exit || { touch $exit_file && exit; } '

# [ Prompt Command ]
normal_prompt_command="analyze_commands_not_found"
export PROMPT_COMMAND="$normal_prompt_command; $post_rc_commands; export PROMPT_COMMAND=$normal_prompt_command"

# [ Globbing and Matching ]
# use extended globbing syntax
shopt -s extglob
# case-insensitive globbing
shopt -s nocaseglob
# case-insensitive pattern-matching
shopt -s nocasematch
# patterns matching no files expand to a null string
# !! don't - tries to expand a single '?', which breaks the cd awesomeness
shopt -u nullglob

# [ TTY startup ]
# Announce OS (I regularly log into machines with different OS's)
echo "[OS: $(uname)]"
# reduce paths
export PATH=$(pathdd $PATH)
export PYTHONPATH=$(pathdd $PYTHONPATH)
# if remote, start tmux unless already started
STARTUP_LOG=~/.shell.init.log
if [ -n "$SSH_CONNECTION" ]; then
    echo "Logged in remotely..." > $STARTUP_LOG
    if [ -z "$TMUX" ]; then
        echo "Checking for tmux..." >> $STARTUP_LOG
        if [ -n "$(command -v tmux)" ]; then
            echo "tmux found. Launching..." >> $STARTUP_LOG
            if [ -n "$(tmux list-sessions | grep -v attached)" ]; then
                echo "unattached sessions found. Attaching..." >> $STARTUP_LOG
                tmux -2 attach -t $(tmux list-sessions | grep -v attached | awk -F: '{print $1}' | head -n 1)
            else
                echo "no unattached sessions found. Creating a new one..." >> $STARTUP_LOG
                tmux -2
            fi
            if [ -f "$exit_file" ]; then
                rm "$exit_file"
            else
                exit $?
            fi
        else
            echo "TMUX not found.  If you want session persistence, you should install TMUX."
        fi
    else
        echo "Active tmux session detected. Skipping tmux launch." >> $STARTUP_LOG
        export TERM=screen-256color
    fi
else
    echo "Logged in locally. Skipping tmux launch." >> $STARTUP_LOG
fi
