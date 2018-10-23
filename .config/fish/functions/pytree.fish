# Defined in - @ line 0
function pytree --description alias\ pytree\ tree\ -I\ \'__pycache__\|\*.egg-info\'\ -C\ -P\ \'\*.py\'
	tree -I '__pycache__|*.egg-info' -C -P '*.py' $argv;
end
