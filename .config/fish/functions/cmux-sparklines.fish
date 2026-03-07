function cmux-sparklines --description "Push tmux sparklines to cmux sidebar (ctrl-c to stop)"
    if not set -q CMUX_WORKSPACE_ID
        echo "Not running inside cmux"
        return 1
    end

    function _cmux_spark_cleanup
        cmux clear-status activity >/dev/null 2>&1
        functions -e _cmux_spark_cleanup
    end
    trap _cmux_spark_cleanup SIGINT

    echo "Pushing tmux sparklines to cmux. Ctrl-C to stop."

    set -l sparkline_file /tmp/tmux-spark-cmux-sparkline
    set -l prev ""

    while true
        if test -f $sparkline_file
            set -l current (cat $sparkline_file 2>/dev/null)
            if test -n "$current" -a "$current" != "$prev"
                cmux set-status activity $current >/dev/null 2>&1
                set prev $current
            end
        else if test -n "$prev"
            cmux clear-status activity >/dev/null 2>&1
            set prev ""
        end
        sleep 1
    end
end
