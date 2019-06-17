echo "Checking taps..."
set brew_tap_list (brew tap)
set desired_brew_tap_list (cat ~/dotfiles/brew-tap-list.txt | awk '{print $1}')
for tap in $brew_tap_list
    echo -n "  found $tap..."
    if not echo $desired_brew_tap_list | ack $tap > /dev/null
        echo -n "not desired.  Untapping..."
        brew untap $tap; or exit 1
        echo "done!"
    else
        echo "great!"
    end
end
for tap in $desired_brew_tap_list
    if not echo $brew_tap_list | ack $tap > /dev/null
        echo -n "  $tap not found.  Tapping..."
        brew tap $tap; or exit 1
        echo "done!"
    end
end
echo "Checking taps... done!"

echo "Checking recipes..."
set brew_list (brew leaves)
set desired_brew_list (cat ~/dotfiles/brew-list.txt | awk '{print $1}')
for recipe in $brew_list
    echo -n "  found $recipe..."
    if not echo $desired_brew_list | ack $recipe > /dev/null
        echo -n "not desired.  Uninstalling..."
        brew rmtree $recipe; or exit 1
        echo "done!"
    else
        echo "great!"
    end
end
for recipe in $desired_brew_list
    if not echo $brew_list | ack $recipe > /dev/null
        echo -n "  $recipe not found.  Installing..."
        brew install $recipe; or exit 1
        echo "done!"
    end
end
echo "Checking recipes... done!"
echo "Upgrading outdated brew recipes..."
brew upgrade; or exit 1
echo -e "\rUpgrading outdated brew recipes... done!"

echo "Checking casks..."
set brew_cask_list (brew cask list)
set desired_brew_cask_list (cat ~/dotfiles/brew-cask-list.txt | awk '{print $1}')
for cask in $brew_cask_list
    echo -n "  found $cask..."
    if not echo $desired_brew_cask_list | ack $cask > /dev/null
        echo -n "not desired.  Uninstalling..."
        brew cask uninstall $cask; or exit 1
        echo "done!"
    else
        echo "great!"
    end
end
for cask in $desired_brew_cask_list
    if not echo $brew_cask_list | ack $cask > /dev/null
        echo -n "  $cask not found.  Installing..."
        brew cask install $cask; or exit 1
        echo "done!"
    end
end
echo "Checking casks... done!"
echo "Upgrading outdated brew casks..."
brew cask upgrade; or exit 1
echo -e "\rUpgrading outdated brew casks... done!"
