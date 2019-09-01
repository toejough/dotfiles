# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.SsDxTT/fish_mode_prompt.fish @ line 2
function fish_mode_prompt --description 'Displays the current mode'
	if test "$fish_bind_mode" != "insert"
        echo (set_color red)"N"(set_color normal)
    end
	#fish_default_mode_prompt
end
