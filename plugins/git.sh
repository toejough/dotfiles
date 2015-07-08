# git commands


function refetch() { git fetch && git rebase -i origin/$1; }
function git-switch() {
    echo
    parent=$(git-remote)
    git fetch --all && git checkout $1 && { git merge --ff-only $parent || git rebase -i $parent; }
    echo
}
function git-update() {
    echo
    echo "Updating git repo..."
    branch=$(git symbolic-ref --short HEAD)
    echo "  current branch is ${branch}"
    git-switch $branch
    echo
}
function git-remote() {
    git rev-parse --abbrev-ref --symbolic-full-name $1@{u}
}
function git-branch-prune() {
    echo
    echo "Pruning branches..."
    if ! $(git branch | grep "* master" > /dev/null 2>&1); then
        echo "ERROR: must be on master"
        return
    fi
    for b in $(git branch | grep -v '^* master$'); do
        if git branch -d $b > /dev/null 2>&1; then
            echo "  deleted caught-up branch $b"
        elif ! git-remote $b > /dev/null 2>&1; then
            git branch -vv | grep $b
            if [[ "yes" == $(yes_or_no "delete remoteless branch $b") ]]; then
                git branch -D $b > /dev/null 2>&1
                echo "  deleted remoteless branch $b"
            fi
        fi
    done
    echo "Remaining branches:"
    git branch -vv | grep -v '^* master$'
    echo
}

function git-install-osx-keychain-helper() {
    # from https://help.github.com/articles/caching-your-github-password-in-git/

    echo
    # Download the helper
    echo "[*] Downloading helper..."
    curl -s -O https://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain
    # Fix the permissions on the file so it can be run
    echo "[*] Setting permissions..."
    chmod u+x git-credential-osxkeychain

    # Move the helper to the path where git is installed
    echo "[*] Moving to git install directory..."
    sudo mv git-credential-osxkeychain "$(dirname $(which git))/git-credential-osxkeychain"
    # Password: [enter your password]

    # Set git to use the osxkeychain credential helper
    echo "[*] Telling git to use the helper..."
    git config --global credential.helper osxkeychain

    # Done
    echo "[*] Done!"
    echo
}
