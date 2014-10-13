# git commands


function refetch() { git fetch && git rebase -i origin/$1; }
function git-switch() {
    echo
    git fetch --all && git checkout $1 && { git merge --ff-only origin/$1 || git rebase -i origin/$1; }
    echo
}
function git-update() {
    echo
    echo "Updating git repo..."
    branch=$(git symbolic-ref --short HEAD)
    echo "  current branch is ${branch}"
    git-switch $(git symbolic-ref --short HEAD)
    echo
}
