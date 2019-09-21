# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.HzCeS4/git-report.fish @ line 2
function git-report
	clear

    echo -e "\nBRANCH\n"
    git log --oneline branch-base.(git name)..local-base.(git name) --color --decorate --stat --reverse | cat

    echo -e "\nLOCAL\n"
    git log --oneline local-base.(git name)..HEAD --color --decorate --stat --reverse | cat

    echo -e "\nSTAGED\n"
    git diff --color --staged | diff-so-fancy

    echo -e "\nUNSTAGED\n"
    git diff --color | diff-so-fancy
end
