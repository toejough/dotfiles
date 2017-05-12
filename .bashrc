# Called by bash automatically for non-login interactive shell.


export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
source /usr/local/bin/virtualenvwrapper.sh
# [ Interactive Shell Check ]
# If somehow this is not an interactive shell, just return
if [ -z "$PS1" ]; then
    return
fi


# [ GLOBALS ]
export UNIVERSAL_SETTINGS_DIR=$HOME/.settings
export UNIVERSAL_BASHRC=$UNIVERSAL_SETTINGS_DIR/bashrc
export LOCAL_SETTINGS_DIR=$HOME/.settings.local
export LOCAL_BASHRC=$LOCAL_SETTINGS_DIR/bashrc
# Assume Awesomeness, unless told otherwise
AWESOME_BASH=1


# [ Pre-config ]
if [ -d $HOME/.settings.local -a -f $HOME/.settings.local/bashrc.before ]; then
    source $HOME/.settings.local/bashrc.before
fi


# [ Universal Config ]
# Run my universal bashrc
if [ -d "$UNIVERSAL_SETTINGS_DIR" -a -f "$UNIVERSAL_BASHRC" ]; then
    source "$UNIVERSAL_BASHRC"
else
    printf "ERROR: Cannot load universal bashrc ('%s' does not exist or is not a file)\n" "$UNIVERSAL_BASHRC"
fi


# [ Local Config ]
# Run my local bash rc
if [ -d "$LOCAL_SETTINGS_DIR" -a -f "$LOCAL_BASHRC" ]; then
    source "$LOCAL_BASHRC"
else
    printf "ERROR: Cannot load local bashrc ('%s' does not exist or is not a file)\n" "$LOCAL_BASHRC"
fi


# [ Exec ]
# Run an environment var
if [[ -n "$STARTUP_COMMAND" ]]; then
    echo "[ Startup Command ]"
    eval $STARTUP_COMMAND
    echo "========================"
fi



