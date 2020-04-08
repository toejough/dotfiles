# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.Nap1FE/ic.fish @ line 2
function ic --description 'cd to a recent directory as chosen with z and fzf'
	cd (z -l | fzf --preview 'lt {-1}' --preview-window down | awk '{print $NF}')
end
