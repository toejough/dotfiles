# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.1OD7kP/post_exec.fish @ line 2
function post_exec --on-event fish_postexec
	set -l last_status $status

    # Last command info if command
    if test -n "$argv"
        echo "CMD: "(set_color yellow)"$argv[1]"
        set_color normal

        echo "MS: "(set_color yellow)"$CMD_DURATION"
        set_color normal

        if test $last_status -eq 0
            echo "RC: "(set_color green)"$last_status"
        else
            echo "RC: "(set_color red)"$last_status"
        end
        set_color normal

        # git info
        if git config --get remote.(git remote 2> /dev/null).url > /dev/null 2>&1
            echo "GIT REMOTE: "(git config --get remote.(git remote).url)
        end
        if git status > /dev/null 2>&1
            echo -n "GIT STATUS: "
            git status -sb
        end
    end

    # PWD on change
    set -l current_dir (pwd)
    if test $last_dir != $current_dir
        set -U last_dir $current_dir
        echo "PWD: "(set_color blue)"$current_dir"
        set_color normal
        lt
    end

    # The current time
    date
end
