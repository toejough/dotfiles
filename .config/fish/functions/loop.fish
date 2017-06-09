function loop
	set count 0
    while [ $status = 0 ]
        set count (math "$count + 1")
        printf "\n\nIteration #%s:\n" $count >&2
        eval $argv
    end
    printf "\n\nFAILED after %s runs." $count >&2
end
