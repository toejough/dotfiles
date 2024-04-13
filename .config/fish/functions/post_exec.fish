# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.1OD7kP/post_exec.fish @ line 2
function post_exec --on-event fish_postexec
    set -l last_status $status

    # Last command info if command
    if test -n "$argv"
        # separate from previous output
        echo

        echo (set_color cyan)"CMD: "(set_color normal)"$argv[1]"

        echo (set_color cyan)"DURATION: "(set_color normal)(echo -n $CMD_DURATION | humanize_duration)
        # The current time
        echo (set_color cyan)"COMPLETED AT: "(set_color normal)(date)

        if test $last_status -eq 0
            echo (set_color cyan)"RC: "(set_color green)"$last_status"(set_color normal)
        else
            echo (set_color cyan)"RC: "(set_color red)"$last_status"(set_color normal)
        end
        # git info
        if git status >/dev/null 2>&1
            if git config --get remote.(git remote 2> /dev/null).url >/dev/null 2>&1
                echo (set_color cyan)"GIT REMOTE: "(set_color normal)(git config --get remote.(git remote).url)
            end
            if test -n "(git status --porcelain)"
                echo -n (set_color cyan)"GIT STATUS: "(set_color normal)
                git status -sb
            end
        end

        # PWD on change
        set -l current_dir (pwd)
        if test $last_dir != $current_dir
            set -U last_dir $current_dir
            echo (set_color cyan)"PWD: "(set_color blue)"$current_dir"(set_color normal)
            lt
        end

        # separate from next command
        echo
    end
end
