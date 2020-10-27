function brewm-update
    if not count $argv > /dev/null
        brewm-update taps; or return 1
        brewm-update recipes; or return 1
        brewm-update casks; or return 1
        return
    end

    set the_type $argv[1]

    switch $the_type
        case taps
            echo "Checking taps..."
            set brew_tap_list (brew tap)
            set desired_brew_tap_list (cat ~/dotfiles/brew-tap-list.txt | awk '{print $1}' | sed -e '/^#/d')
            for tap in $brew_tap_list
                echo -n "  found $tap..."
                if not echo $desired_brew_tap_list | ack $tap > /dev/null
                    echo -n "not desired.  Untapping..."
                    brew untap $tap; or return 1
                    echo "done!"
                else
                    echo "great!"
                end
            end
            for tap in $desired_brew_tap_list
                if not echo $brew_tap_list | ack $tap > /dev/null
                    echo -n "  $tap not found.  Tapping..."
                    brew tap $tap; or return 1
                    echo "done!"
                end
            end
            echo "Checking taps... done!"
        case recipes
            echo "Checking recipes..."
            # use brew leaves for checking the top-level installations - these are the packages which nothing
            # else depends on.  If they're not explicitly desired, they can be removed.
            set brew_list (brew leaves)
            set desired_brew_list (cat ~/dotfiles/brew-recipe-list.txt | awk '{print $1}' | sed -e '/^#/d')
            for recipe in $brew_list
                echo -n "  found $recipe..."
                if not echo $desired_brew_list | ack $recipe > /dev/null
                    echo -n "not desired.  Uninstalling..."
                    brew rmtree $recipe; or return 1
                    echo "done!"
                else
                    echo "great!"
                end
            end
            # different list now - we want to see what's already installed, which should be the full
            # list of installed packages, not just the ones with no dependencies
            set -a brew_list (brew list --formula)
            for recipe in $desired_brew_list
                if not echo $brew_list | ack $recipe > /dev/null
                    echo -n "  $recipe not found.  Installing..."
                    brew install $recipe; or return 1
                    echo "done!"
                end
            end
            echo "Checking recipes... done!"
            echo "Upgrading outdated brew recipes..."
            brew upgrade; or return 1
            echo -e "\rUpgrading outdated brew recipes... done!"
        case casks
            echo "Checking casks..."
            set brew_cask_list (brew list --cask)
            set desired_brew_cask_list (cat ~/dotfiles/brew-cask-list.txt | awk '{print $1}' | sed -e '/^#/d')
            for cask in $brew_cask_list
                echo -n "  found $cask..."
                if not echo $desired_brew_cask_list | ack $cask > /dev/null
                    echo -n "not desired.  Uninstalling..."
                    brew cask uninstall $cask; or return 1
                    echo "done!"
                else
                    echo "great!"
                end
            end
            for cask in $desired_brew_cask_list
                if not echo $brew_cask_list | ack $cask > /dev/null
                    echo -n "  $cask not found.  Installing..."
                    brew cask install $cask; or return 1
                    echo "done!"
                end
            end
            echo "Checking casks... done!"
            echo "Upgrading outdated brew casks..."
            brew upgrade --cask; or return 1
            echo -e "\rUpgrading outdated brew casks... done!"
        case '*'
            echo "Unknown brew type '$argv[1]' - cannot update"
            return 1
    end
end
