function brewm-remove
    if test (count $argv) -eq 0
        echo "At least one package name is required!"
        return 1
    end

    set -l package_file ~/dotfiles/brew-package-list.txt
    set -l existing (cat $package_file | awk '{print $1}')

    for item in $argv
        if contains -- $item $existing
            echo -n "  $item found. Removing..."
            rg -Fv $item $package_file >$package_file.tmp; and mv $package_file.tmp $package_file
            echo "done!"
        else
            echo "  $item already not present. Great!"
        end
    end

    brewm update; or return 1
end
