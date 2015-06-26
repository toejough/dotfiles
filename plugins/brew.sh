# brew extras

function brew-find-cruft() {
    roots=$(echo $(brew leaves))
    expected_roots=$(echo $(cat $rc_dir/brew-roots.txt))
    cruft=$(python -c "print '\n'.join([m for m in '$roots'.split() if m not in '$expected_roots'.split()])")
    if [[ -n $cruft ]]; then
        echo -e "$cruft"
    fi
}
function brew-de-cruft() {
    all_cruft=''
    cruft=$(brew-find-cruft)
    while [[ -n $cruft ]]; do
        echo "Removing Cruft:"
        echo -e "$cruft"
        for m in $cruft; do 
            brew uninstall $m
            all_cruft=$(echo $all_cruft $m)
        done
        cruft=$(brew-find-cruft)
    done
    echo "Done - no more cruft found."
    if [[ -n $all_cruft ]]; then
        echo "All cruft removed:"
        for m in $all_cruft; do 
            echo $m
        done
    fi
}
