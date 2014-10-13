# tmux


function exit-tmux () {
    if [[ -n $USR_TMUX_COMM_FILE ]]; then
        touch $USR_TMUX_COMM_FILE
        exit
    else
        echo "::ERROR:: No tmux comm file found.  Use 'exit' to exit completely."
    fi
}


function tmux-launch () {
    # don't launch tmux if we're already inside a tmux session
    log-rc "------------------------"
    if [ -z "$TMUX" ]; then
        log-rc -n "* Checking for tmux..."
        if [ -n "$(command -v tmux)" ]; then
            log-rc "tmux found."
            log-rc -n "* generating communication file..."
            export USR_TMUX_COMM_FILE=$(sed "s/ /-/g" <<< "/tmp/tmux-$(uuidgen)-$USER-$HOSTNAME-$(date)")
            log-rc " Done ($USR_TMUX_COMM_FILE)."
            log-rc -n "* Searching for unattached sessions..."
            unattached_sessions=$(tmux list-sessions | grep -v attached)
            if [ -n "$unattached_sessions" ]; then
                log-rc "found:"
                log-rc "$unattached_sessions"
                first_session=$(tmux list-sessions | grep -v attached | awk -F: '{print $1}' | head -n 1)
                log-rc "* attaching to '${first_session}'..."
                tmux -2 attach -t "$first_session"
            else
                log-rc "none found."
                log-rc "* Creating a new session..."
                tmux -2
            fi
            # At this point, we've entered either an existing session or a new one, and have exited again
            # If the comm file exists, remove it and don't exit from this level.
            if [[ -f $USR_TMUX_COMM_FILE ]]; then
                log-rc "::NOTICE:: Exited from tmux with exit-tmux."
                rm $USR_TMUX_COMM_FILE
            else
                exit
            fi
        else
            log-rc "tmux not found."
            log-rc "::NOTICE:: If you want session persistence, you should install TMUX."
        fi
    else
        log-rc "* Active tmux session detected. Skipping tmux launch."
        export TERM=screen-256color
        #tmux source-file ~/.tmux.conf
    fi
    log-rc "------------------------"
}
