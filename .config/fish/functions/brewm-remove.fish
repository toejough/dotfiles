function brewm-remove
    set num_args (count $argv)
    if test $num_args -lt 2
        echo "Both brew type and at least one item are required!"
        echo
        return 1
    end

    set the_type $argv[1]
    set items $argv[2..(count $argv)]

    switch $the_type
        case tap recipe cask
            echo "Checking "$the_type"s..."
            set the_file ~/dotfiles/brew-"$the_type"-list.txt
            set brew_list (cat $the_file | awk '{print $1}')
            for item in $items
                if echo $brew_list | ack $item > /dev/null
                    echo -n "  $item found.  Removing..."
                    cat $the_file | ack -v $item > tmp.txt; and mv tmp.txt $the_file
                    echo "done!"
                else
                    echo "  $item already not present.  Great!"
                end
            end
        case '*'
            echo "Unknown brew type '$argv[1]' - cannot remove"
            return 1
    end
    brewm update $the_type"s"; or return 1
end
