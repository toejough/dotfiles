
# [ Ideas ]
# - dedup history on shell exit
# - a real 'bottom' func that goes to the lowest dir

# [ Paths ]
#make bash use absolute paths!
set -P
# My utility paths...
utils_bin=~/tools/bin
utils_lib=~/tools/lib
# Directory shortcuts...
shortcuts=~/.dirlinks
# Update the system paths
export PATH=$utils_bin:$PATH
export PYTHONPATH=$utils_lib:$PYTHONPATH
export CDPATH=.:$shortcuts

# [ Defaults ]
export EDITOR=vim
export PAGER=less
export LANG=en_US.UTF-8

# [ Readline ]
export INPUTRC=~/.inputrc
# tell readline to re-read the inputrc
bind -f $INPUTRC

# [ Completion ]
# programmable completion is enabled
shopt -s progcomp
# use bash completion!
if [ "$(uname)" = "Linux" ]; then
    . /etc/profile.d/bash_completion.sh
else
    . ~/.bash_completion
fi
# allow cd to autocorrect small errors
shopt -s cdspell
# allow dir names to be autocorrected for small erors
shopt -s dirspell
# complete @<text> with hostnames if possible
shopt -s hostcomplete

# [ History ]
# append to history instead of replacing history on shell exit
shopt -s histappend
# unlimited history
unset HISTSIZE
unset HISTFILESIZE
# keep only the latest copy of a command
export HISTCONTROL='erasedups'
# add timestamps
export HISTTIMEFORMAT=': %H:%M:%S %m/%d/%Y; '
# History manipulation
update_global_history='history -a'
update_local_history='history -c && history -r'
sync_history="$update_global_history && $update_local_history"

# [ Prompts ]
# prompt strings undergo variable expansion after prompt expansion
shopt -s promptvars
# -Colors- #
DEFAULT='\[\e[0;39m\]'
WHITE='\[\e[0;37m\]'
BOLD_WHITE='\[\e[1;37m\]'
GREEN='\[\e[0;32m\]'
RED='\[\e[0;31m\]'
YELLOW='\[\e[0;33m\]'
# -helper functions- #
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
# -actual prompts- #
# PS1 is main prompt
# Set PS1 to be [ rc][username@host:curdir (git branch)](jobs)$
PS1=\
"$RED"'$(__rc_ps1 $?)'\
"$DEFAULT[$BOLD_WHITE\u$DEFAULT@\h:\W$GREEN"'$(__git_ps1)'"$DEFAULT]"\
"$YELLOW"'$(__jobs_ps1 '"\j"')'\
"$DEFAULT$ "
# PS2 is line continuation prompt
PS2='>'
# PS3 is 'select' prompt
PS3='<<Choose an option>>'
# PS4 is 'xtrace' prompt - used with set -x for debugging
PS4='>'"$RED"' $LINENO: '"$DEFAULT"

# [ Prompt Command ]
#unset PROMPT_COMMAND
export PROMPT_COMMAND="$sync_history"

# [ Aliases ]
# clear all aliases
\unalias -a
# use aliases
shopt -s expand_aliases
#make resourcing this file easier
alias resource="source ~/.bash_profile"

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
alias mv="mv -iv"
# [ -ln- ]
#default to symbolic link (s), prompt before overwrite (i), print verbose
# output (v), [and on FreeBSD warn if the source doesn't exist (w)] for ln
if [ "$(uname)" = "Linux" ]; then
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
    builtin pushd $@
    # figure out what's at the top of the stack now
    local zero=$(dirs -v | head -1 | awk '{print $2}')
    # if there's an entry for this directory elswhere in the stack...
    if [[ $(dirs -v | tail +2 | grep -e '[[:space:]]\+[[:digit:]]\+[[:space:]]\+'"$zero"'$') ]]; then
        # get the oldest matching index
        local index=$(dirs -v | tail +2 | grep -e '[[:space:]]\+[[:digit:]]\+[[:space:]]\+'"$zero"'$' | awk '{print $1}' | sed '$!d')
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
    echo $zero > ~/.lastdir
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
    if [[ "$1" == "?" ]]; then
        dirs -v
    # go to global lastdir if it exists
    elif [[ "$1" == "!" ]]; then
        local last_dir=$(cat ~/.lastdir)
        if [[ $last_dir ]]; then
            pushd $last_dir > /dev/null
        else
            echo 'No lastdir found!' >&2
            return 1
        fi
    # go back a dir
    elif [[ "$1" == "-" ]]; then
        popd > /dev/null
    # go home
    elif [[ $# -eq 0 ]]; then
        pushd ~ > /dev/null
    # pushd
    else
        pushd $@ > /dev/null
    fi
}

# [ Utility Functions ]
# [ -git- ]
function refetch() { git fetch && git rebase -i origin/$1; }
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
#autotmux escape
exit_file=$HOME/noexit
alias exittmux='[ -z "$TMUX" ] && exit || { touch $exit_file && exit; } '

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
#trap "err_handle" ERR - when a command is not found, call our commander program.
function command_not_found_handle () { commander $@; }

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
echo [OS: $(uname)]
# run the phrases utility
phrases
# reduce paths
export PATH=$(pathdd $PATH)
export PYTHONPATH=$(pathdd $PYTHONPATH)
# start tmux unless already started
if [ -z "$TMUX" ]; then
    echo "Checking for tmux..."
    if [ -n "$(command -v tmux)" ]; then
        echo "tmux found. Launching..."
        tmux -2
        if [ -f "$exit_file" ]; then
            rm "$exit_file"
        else
            exit $?
        fi
    else
        echo "tmux not found."
    fi
else
    echo "Active tmux session detected. Skipping tmux launch."
fi

# [ Local Customizations ]
local_bash_profile="~/.settings/local/bash_profile"
if [ -f "$local_bash_profile" -a -r "$local_bash_profile" ]; then
    source $local_bash_profile
fi
