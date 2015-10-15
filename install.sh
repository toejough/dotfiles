#! /usr/bin/env bash

echo
echo 'Installing Dotfiles...'
echo '[*] Moving ~/dotfiles to ~/.settings'
if [[ -e ~/.settings ]]; then
    echo '[!]   ERROR: ~/.settings exists.  Refusing to overwrite.'
    echo
    exit 1
fi
mv ~/dotfiles ~/.settings
# TODO: only move and refuse to update if we're IN dotfiles to start with.
# TODO: otherwise warn about dotfiles existing
# TODO: and just override anything here
# TODO: add a plugin for updating this, so that update-all will update this, too
# TODO: make the update do a git fetch and check - if there's no update, don't re-run anything
# TODO: make a re-install script, which: fresh git-clones the repo, moves all the installed things, installs, then deletes old
# TODO: even before ^, make the install atomic - install everything to .tmpxyz.dotfiles and then to .settings, then link, with easy rollback if anything goes wrong.

links=" \
.bashrc \
.bash_profile \
.tmux.conf \
.inputrc \
.vimrc.local \
.vimrc.bundles.local \
.vimrc.before.local \
.gitconfig \
.prospector.yaml \
"

completed_links=""

function rollback() {
    echo '[!] Initiating rollback'
    for link in $completed_links; do
        echo "[*] removing ~/$link"
        rm ~/$link	
    done
    echo '[*] moving ~/.settings back to ~/dotfiles'
    mv ~/.settings ~/dotfiles
}

for link in $links; do
    echo "[*] linking ~/.settings/$link to ~/$link"
    if [[ -e ~/$link ]]; then
        echo "[!]   ERROR: ~/$link exists.  Refusing to overwrite."
        rollback
        echo
        exit 1
    fi
    ln -s ~/.settings/$link ~/$link
    completed_links="$completed_links $link"
done

echo '...installation complete.'
echo
echo '...to change the login shell:'
echo '  add <path-to-shell> to /etc/shells'
echo '  run chsh -s <path-to-shell>'
echo '  if on osx, reboot (sorry, no known way around this)'

exit 0
