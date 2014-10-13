# Mosh


# stale mosh sessions
alias mosh-view-stale="who | grep $(whoami) | grep mosh | grep -v via"
alias mosh-kill-stale="mosh-view-stale | tr '[]' ' ' | awk '{print \$(NF-1)}' | xargs -pn 1 kill"
