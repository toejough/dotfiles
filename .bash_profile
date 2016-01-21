# Called by bash automatically for login interactive shell.


# [ Interactive Shell Check ]
# If somehow this is not an interactive shell, just return
if [ -z "$PS1" ]; then
    return
fi


# [ GLOBALS ]
BASHRC=$HOME/.bashrc


# [ Interactive Shell Init ]
# Run .bashrc
if [ -f "$BASHRC" ]; then
    source "$BASHRC"
fi

# [ Post-RC GLOBALS ]
export UNIVERSAL_BASH_PROFILE=$UNIVERSAL_SETTINGS_DIR/bash_profile
export LOCAL_BASH_PROFILE=$LOCAL_SETTINGS_DIR/bash_profile


# [ Universal Login Config ]
# Run my universal bash profile
if [ -d "$UNIVERSAL_SETTINGS_DIR" -a -f "$UNIVERSAL_BASH_PROFILE" ]; then
    source "$UNIVERSAL_BASH_PROFILE"
else
    printf "ERROR: Cannot load universal bash_profile ('%s' does not exist or is not a file)\n" "$UNIVERSAL_BASH_PROFILE"
fi


# [ Local Login Config ]
# Run my local bash profile
if [ -d "$LOCAL_SETTINGS_DIR" -a -f "$LOCAL_BASH_PROFILE" ]; then
    source "$LOCAL_BASH_PROFILE"
else
    printf "ERROR: Cannot load local bash_profile ('%s' does not exist or is not a file)\n" "$LOCAL_BASH_PROFILE"
fi

test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash
