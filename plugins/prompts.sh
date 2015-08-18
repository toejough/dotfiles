#  Prompt-related functions and settings

#  Requires "fullpath" from the paths plugin
plugins-load 'path.sh'

# prompt strings undergo variable expansion after prompt expansion
shopt -s promptvars

# [ Colors ]
DEFAULT='\[\e[0;39m\]'
WHITE='\[\e[0;37m\]'
BOLD_WHITE='\[\e[1;37m\]'
GREEN='\[\e[0;32m\]'
RED='\[\e[0;31m\]'
YELLOW='\[\e[0;33m\]'
ORANGE='\[\e[38;5;208m\]'
CYAN='\[\e[0;36m\]'
GREY='\[\e[38;5;245m\]'

# [ Helper Funcs ]
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
if [ -z $(command -v __git_ps1) ]; then
    function __git_ps1 { :
    }
fi
function __ssh () {
    if [ -n "$SSH_CONNECTION" ]; then
        echo ""
    fi
}
function __time_ps1 () {
    echo "$(date +'%I:%M %p') "
}
# [ -Prompt Definitions- ]
# PS1 is main prompt
# Set PS1 to be ssh_lock_symbol[rc][username@host:curdir (git branch)<orphaned>](jobs)$
PROMPT=$(python -c "l=${SHLVL}; p = '▶'*l if l < 6 else '(SHLVL:{})▶'.format(l); print p,")
PS1=\
"$RED"'$(__rc_ps1 $?)'\
"$GREY"'$(__time_ps1)'\
"$DEFAULT["\
"$BOLD_WHITE\u"\
"$DEFAULT@\h:\w"\
"$DEFAULT]\n╰"\
"$CYAN"'$(__ssh)'\
"$GREEN"'$(__git_ps1)'\
"$ORANGE"'$(__orphaned_ps1)'\
"$YELLOW"'$(__jobs_ps1 '"\j"')'\
"$DEFAULT $PROMPT "
# PS2 is line continuation prompt
PS2='▶'
# PS3 is 'select' prompt
PS3='<<Choose an option>>'
# PS4 is 'xtrace' prompt - used with set -x for debugging
PS4='▶'"$RED"' $LINENO: '"$DEFAULT"

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

plugins-load 'commands.sh'
normal_prompt_command="analyze_commands_not_found"
export PROMPT_COMMAND="$normal_prompt_command; echo '[ Post RC commands ]'; $post_rc_commands; echo '========================'; log-rc; export PROMPT_COMMAND=$normal_prompt_command"
