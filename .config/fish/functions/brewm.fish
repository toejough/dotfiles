function brewm
    set the_command $argv[1]
    set num_args (count $argv)
    if test $num_args -lt 2
        set args
    else
        set args $argv[2..$num_args]
    end

    switch $the_command
        case add
            brewm-add $args; or return 1
        case remove
            brewm-remove $args; or return 1
        case update
            brewm-update $args; or return 1
        case '*'
            echo "Sorry, I don't know what '$the_command' means."
            echo
            return 1
    end
end
