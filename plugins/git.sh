# git commands
# In addition, if you set GIT_PS1_SHOWDIRTYSTATE to a nonempty value,
# unstaged (*) and staged (+) changes will be shown next to the branch
# name.  You can configure this per-repository with the
# bash.showDirtyState variable, which defaults to true once
# GIT_PS1_SHOWDIRTYSTATE is enabled.
GIT_PS1_SHOWDIRTYSTATE=1
#
# You can also see if currently something is stashed, by setting
# GIT_PS1_SHOWSTASHSTATE to a nonempty value. If something is stashed,
# then a '$' will be shown next to the branch name.
GIT_PS1_SHOWSTASHSTATE=1
#
# If you would like to see if there're untracked files, then you can set
# GIT_PS1_SHOWUNTRACKEDFILES to a nonempty value. If there're untracked
# files, then a '%' will be shown next to the branch name.  You can
# configure this per-repository with the bash.showUntrackedFiles
# variable, which defaults to true once GIT_PS1_SHOWUNTRACKEDFILES is
# enabled.
GIT_PS1_SHOWUNTRACKEDFILES=1
#
# If you would like to see the difference between HEAD and its upstream,
# set GIT_PS1_SHOWUPSTREAM="auto".  A "<" indicates you are behind, ">"
# indicates you are ahead, "<>" indicates you have diverged and "="
# indicates that there is no difference. You can further control
# behaviour by setting GIT_PS1_SHOWUPSTREAM to a space-separated list
# of values:
#
#     verbose       show number of commits ahead/behind (+/-) upstream
#     name          if verbose, then also show the upstream abbrev name
#     legacy        don't use the '--count' option available in recent
#                   versions of git-rev-list
#     git           always compare HEAD to @{upstream}
#     svn           always compare HEAD to your SVN upstream
GIT_PS1_SHOWUPSTREAM='auto'
#
# You can change the separator between the branch name and the above
# state symbols by setting GIT_PS1_STATESEPARATOR. The default separator
# is SP.
#
# By default, __git_ps1 will compare HEAD to your SVN upstream if it can
# find one, or @{upstream} otherwise.  Once you have set
# GIT_PS1_SHOWUPSTREAM, you can override it on a per-repository basis by
# setting the bash.showUpstream config variable.
#
# If you would like to see more information about the identity of
# commits checked out as a detached HEAD, set GIT_PS1_DESCRIBE_STYLE
# to one of these values:
#
#     contains      relative to newer annotated tag (v1.6.3.2~35)
#     branch        relative to newer tag or branch (master~4)
#     describe      relative to older annotated tag (v1.6.3.1-13-gdd42c2f)
#     default       exactly matching tag
#
GIT_PS1_DESCRIBE_STYLE=branch
# If you would like a colored hint about the current dirty state, set
# GIT_PS1_SHOWCOLORHINTS to a nonempty value. The colors are based on
# the colored output of "git status -sb" and are available only when
# using __git_ps1 for PROMPT_COMMAND or precmd.
GIT_PS1_SHOWCOLORHINTS=1


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
