# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.DfCf5b/fish_greeting.fish @ line 2
function fish_greeting
	clear
    set -U dirprev $dirprev
    set -U dirnext $dirnext
	echo "DIR: "(set_color blue)(pwd)
end
