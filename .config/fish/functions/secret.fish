function secret --description alias\ secret\ read\ -s\ -p\ \"set_color\ -i\ red\;\ echo\ -n\ \'SECRET\ GOES\ HERE:\ \'\;\ set_color\ normal\"
	read -s -p "set_color -i red; echo -n 'SECRET GOES HERE: '; set_color normal" $argv;
end
