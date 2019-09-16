# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.yFBFD4/iv.fish @ line 1
function iv --description 'nvim open file chosen by fzf from most recently nvim-opened files'
	nvim (begin; for f in (vim -e -c 'echo v:oldfiles|qall' --headless -u NONE 2>&1 | tr "'" '"' | jq .[] -r | sort -u); if test -f $f; echo $f; end; end; end | fzf)
end