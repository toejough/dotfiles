function brewm-update
    set -l package_file ~/dotfiles/brew-package-list.txt

    # Parse desired packages from the list (strip comments, blank lines)
    set -l desired
    set -l cask_flags
    for line in (cat $package_file | sed -e '/^#/d' -e '/^$/d')
        set -l name (echo $line | awk '{print $1}')
        # Check if --cask appears anywhere on the line (before or after comment)
        if echo $line | rg -q -- '--cask'
            set -a desired $name
            set -a cask_flags '--cask'
        else
            set -a desired $name
            set -a cask_flags ''
        end
    end

    # Phase 1 — Remove unwanted packages
    echo "Checking installed packages..."
    set -l removable (brew leaves; brew list --cask)
    for pkg in $removable
        if not contains -- $pkg $desired
            read -P "  $pkg is installed but not in the list. (k)eep / (u)ninstall / (a)dd to list? " action
            switch $action
                case k K
                    echo "  Skipping $pkg."
                case u U
                    echo -n "  Uninstalling $pkg..."
                    brew uninstall $pkg; or return 1
                    echo "done!"
                case a A
                    echo "$pkg" >>$package_file
                    echo "  Added $pkg to package list."
                case '*'
                    echo "  Unrecognized choice, skipping $pkg."
            end
        end
    end
    echo "Running autoremove..."
    brew autoremove; or return 1

    # Phase 2 — Install missing packages
    echo "Checking for missing packages..."
    set -l installed (brew list)
    for i in (seq (count $desired))
        set -l pkg $desired[$i]
        if not contains -- $pkg $installed
            echo -n "  $pkg not found. Installing..."
            if test -n "$cask_flags[$i]"
                brew install --cask $pkg; or return 1
            else
                brew install $pkg; or return 1
            end
            echo "done!"
        end
    end

    # Phase 3 — Upgrade
    echo "Upgrading outdated packages..."
    brew upgrade; or return 1
    echo "Upgrading outdated packages... done!"
end
