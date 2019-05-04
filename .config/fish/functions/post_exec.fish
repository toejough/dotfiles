# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.WrK4dT/post_exec.fish @ line 2
function post_exec --on-event fish_postexec
	set -l last_status $status

    # Last command info if command
    if test -n "$argv[1]"
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
    end

    # PWD on change
    set -l current_dir (pwd)
    if test $last_dir != $current_dir
        set -U last_dir $current_dir
        echo "PWD: "(set_color blue)"$current_dir"
        set_color normal
    end
end
