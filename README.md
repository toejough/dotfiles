Various dotfiles (rc's) that I personally use.

# Fish   

I use the [fish shell](https://fishshell.com/).  Config is in `.config/fish`.

The `.install.fish` script will:
* install the contained `.config/fish/config.fish` base config
* install the contained `.config/fish/functions` autofunctions
* link the contained `.config/fish/fishd.universal` to the existing universal fish config file for the host.

# Git

My preferred git commit template is at `git-commit-template`.

# Tmux

`.tmux.conf` contains my tmux config

# Vim

`.vimrc` contains my vimrc.  It consists of:
* non-plugin config (like tabs, backspace, search, etc)
* plugin manager installation if no manager is present (I use `Plug`)
* plugin installation
* plugin-specific config

See the file for more details - it's not that long, and everything is commented.

# Slate

Slate needs updating/replacing, but I currently use it for rudimentary window management on osx.
