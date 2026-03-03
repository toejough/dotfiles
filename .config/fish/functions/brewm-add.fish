function brewm-add
    set -l cask_flag ''
    set -l items

    for arg in $argv
        switch $arg
            case --cask
                set cask_flag ' --cask'
            case '*'
                set -a items $arg
        end
    end

    if test (count $items) -eq 0
        echo "At least one package name is required!"
        return 1
    end

    set -l package_file ~/dotfiles/brew-package-list.txt
    set -l existing (cat $package_file | awk '{print $1}')

    for item in $items
        if not contains -- $item $existing
            echo -n "  $item not found. Adding..."
            echo "$item$cask_flag" >>$package_file
            echo "done!"
        else
            echo "  $item already present. Great!"
        end
    end

    brewm update; or return 1
end
