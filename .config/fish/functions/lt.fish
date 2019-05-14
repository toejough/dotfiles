# Defined in - @ line 1
function lt --description 'alias lt tree -ahtCDF -L 1 --du'
	tree -ahtCDF -I '.git' -L 1 --du $argv;
end
