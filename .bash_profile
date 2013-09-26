# If somehow this is not an interactive shell, just return
if [ -z "$PS1" ]; then
    return
fi

# Run .bashrc
if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi
# Run my universal bash profile
if [ -d $HOME/.settings -a -f $HOME/.settings/bash_profile ]; then
    source $HOME/.settings/bash_profile
fi
# Run my local bash profile
if [ -d $HOME/.settings.local -a -f $HOME/.settings.local/bash_profile ]; then
    source $HOME/.settings.local/bash_profile
fi
