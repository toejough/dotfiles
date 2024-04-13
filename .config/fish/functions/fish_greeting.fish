# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.LReYi6/fish_greeting.fish @ line 2
function fish_greeting
	clear
	set -l current_dir (pwd)
	if test $last_dir != $current_dir
		set -U last_dir $current_dir
	end
	echo (set_color cyan)"PWD: "(set_color blue)"$current_dir"(set_color normal)
	lt
end
