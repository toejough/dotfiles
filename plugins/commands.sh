# meta-commands


# what is a command?
function whatis {
    answer=$(command -V $1)
    if [ -n "$answer" ]; then
        echo -e "$answer"
    else
        echo "'$1' not found"
    fi
}

# recored commands not found
not_found_file=~/.commands_not_found
function command_not_found_handle {
    echo "$1" >> $not_found_file;
    echo "Unknown command: $1"
}

# fat-finger analysis
function analyze_commands_not_found () {
    if [ -e $not_found_file ]; then
        local unrecognized=$(tail -n 1 $not_found_file);
        local last_command=$(history | tail -n 1 | awk '{ print $5 }');
        if [ "$unrecognized" == "$last_command" ]; then
            local count=$(grep -c "$unrecognized" $not_found_file);
            if [ $count -gt 1 ]; then
                local yn=$(yes_or_no 'This command has been entered before.  Would you like to create an alias?');
                if [ "$yn" == "yes" ]; then
                    local meant_to_type;
                    read -p "Please enter the text you meant to type: " meant_to_type;
                    echo "alias $unrecognized='$meant_to_type'" >> $mistype_aliases_file;
                    echo $(grep -v $unrecognized $not_found_file) > $not_found_file
                    source $mistype_aliases_file
                fi
            fi
        fi
    fi
}

# implement aliases for commonly mistyped commands
mistype_aliases_file=~/.mistype.aliases
if [ -e $mistype_aliases_file ]; then
    source $mistype_aliases_file
fi

