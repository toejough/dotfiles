# Defined in /var/folders/94/q46vzxqd5855jk2zbwqj5mbm0000gn/T//fish.BnMxeP/preview.fish @ line 2
function preview
    set thing (string trim $argv[1])
    # files
    if test -f thing
        bat --color always $thing
    # dirs
    else if test -d thing
        lt $thing
    # commits/branches
    else if git rev-parse --verify --quiet $thing &> /dev/null
        git log --graph --oneline --decorate --color $thing
    # other
    else
        # commits/branches from a worktree
        set maybe_hash (echo $thing | awk '{print $2}')
        if git rev-parse --verify --quiet $maybe_hash &> /dev/null
            git log --graph --oneline --decorate --color $maybe_hash
        # idk, let the built-in fzf vim preview do its thing
        else
            echo "$thing"
            #echo "Unable to preview '$thing'"
            #return 1
        end
    end
end
