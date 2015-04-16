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

links=" \
.bashrc \
.bash_profile \
.tmux.conf \
.inputrc \
.vimrc.local \
.vimrc.bundles.local \
.vimrc.before.local \
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

exit 0
