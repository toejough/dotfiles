# If somehow this is not an interactive shell, just return
if [ -z "$PS1" ]; then
    return
fi

# Run my universal bash rc
if [ -d $HOME/.settings -a -f $HOME/.settings/bashrc ]; then
    source $HOME/.settings/bashrc
fi
# Run my local bash rc
if [ -d $HOME/.settings.local -a -f $HOME/.settings.local/bashrc ]; then
    source $HOME/.settings.local/bashrc
fi
