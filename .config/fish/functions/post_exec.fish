function post_exec --on-event fish_postexec
    set -l last_status $status

    if test -n "$argv"
        echo
        echo (set_color cyan)"CMD: "(set_color normal)"$argv[1]"
        echo (set_color cyan)"DURATION: "(set_color normal)(echo -n $CMD_DURATION | humanize_duration)
        echo (set_color cyan)"COMPLETED AT: "(set_color normal)(date)
        if test $last_status -eq 0
            echo (set_color cyan)"RC: "(set_color green)"$last_status"(set_color normal)
        else
            echo (set_color cyan)"RC: "(set_color red)"$last_status"(set_color normal)
        end
        echo
    end
end
