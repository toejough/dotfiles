function brewm-add
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
                if not echo $brew_list | ack $item > /dev/null
                    echo -n "  $item not found.  Adding..."
                    echo $item >> $the_file
                    echo "done!"
                else
                    echo "  $item already present.  Great!"
                end
            end
        case '*'
            echo "Unknown brew type '$argv[1]' - cannot add."
            return 1
    end
    brewm update $the_type"s"; or return 1
end
