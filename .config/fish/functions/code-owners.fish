# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.LdHTJP/code-owners.fish @ line 2
function code-owners
	echo -e "\nCHANGED FILES"
    git diff --name-only --diff-filter 'CDMRTUXB' branch-base.(git name)
	set changed_files (git diff --name-only --diff-filter 'CDMRTUXB' branch-base.(git name))

    echo -e "\nCOMMITTERS"
    echo $changed_files | \
    tr ' ' \n | \
    xargs -L1 git blame --line-porcelain origin/master | \
    sed -n 's/^author //p' | \
    sort | \
    uniq

    echo -e "\nLINES CHANGED"
    # line breaks being translated to just spaces screws things up - got to re-run the whole thing here.
    git diff --name-only --diff-filter 'CDMRTUXB' branch-base.(git name) | \
    xargs -L1 -J% git blame --line-porcelain origin/master % | \
    sed -n 's/^author //p' | \
    sort | \
    uniq | \
    xargs -L1 -I'%%' fish -c 'git log --numstat --pretty="" --author="%%" -- (git diff --minimal --name-only --diff-filter "CDMRTUXB" branch-base.(git name)) | awk \'{change+=$1; change+=$2} END {printf("%d\t%%\n", change)}\'' | \
    sort -rh
end
