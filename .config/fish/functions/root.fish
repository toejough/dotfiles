# Defined in - @ line 1
function root --description 'alias root cd (git rev-parse --show-toplevel)'
	cd (git rev-parse --show-toplevel) $argv;
end
