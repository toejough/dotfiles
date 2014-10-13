# shell behavior


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

# do use US-English and UTF-8
export LANG=en_US.UTF-8

# don't check for new mail all the time
unset MAILCHECK
