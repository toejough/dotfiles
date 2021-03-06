# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.aET126/preview.fish @ line 2
function preview
    set thing (string trim $argv[1])
    # files
    if test -f thing
        bat --color always $thing
    # dirs
    else if test -d thing
        lt $thing
    # commits/branches
    else if git rev-parse --verify --quiet $thing
        git log --graph --oneline --decorate --color $thing
    else
        # commits/branches from a worktree
        set maybe_hash (echo $thing | awk '{print $2}')
        if git rev-parse --verify --quiet $maybe_hash
            git log --graph --oneline --decorate --color $maybe_hash
        else
            echo "Unable to preview '$thing'"
            return 1
        end
    end
end
