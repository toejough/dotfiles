# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.BnGOKX/ic.fish @ line 1
function ic --description 'cd to a recent directory as chosen with z and fzf'
	cd (z -l | fzf | awk '{print $NF}')
end
