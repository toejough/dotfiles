set brew_list (brew leaves)
for recipe in (cat ~/dotfiles/brew-list.txt)
    echo -n "checking for $recipe..."
    if not echo $brew_list | ack $recipe > /dev/null
        echo "not found.  Installing..."
        brew install $recipe
    end
    echo "found!"
end
echo "Upgrading outdated brew recipes..."
brew update

set brew_cask_list (brew cask list)
for cask in (cat ~/dotfiles/brew-cask-list.txt)
    echo -n "checking for $cask..."
    if not echo $brew_cask_list | ack $cask > /dev/null
        echo "not found.  Installing..."
        brew cask install $cask
    end
    echo "found!"
end
echo "Upgrading outdated brew casks..."
brew cask upgrade
