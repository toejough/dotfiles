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
            set desired_brew_tap_list (cat ~/dotfiles/brew-tap-list.txt | awk '{print $1}')
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
            set brew_list (brew leaves)
            set desired_brew_list (cat ~/dotfiles/brew-recipe-list.txt | awk '{print $1}')
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
            set brew_cask_list (brew cask list)
            set desired_brew_cask_list (cat ~/dotfiles/brew-cask-list.txt | awk '{print $1}')
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
            brew cask upgrade; or return 1
            echo -e "\rUpgrading outdated brew casks... done!"
        case '*'
            echo "Unknown brew type '$argv[1]' - cannot update"
            return 1
    end
end
