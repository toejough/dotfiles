# Defined in /var/folders/v5/mgpjg7ms68n_tb2mfljgy1d40000gn/T//fish.ZPaOpL/dedup.fish @ line 2
function dedup
    if test (count $argv) = 1
        set -l newvar
        set -l count 0
        for v in $$argv
            if contains -- $v $newvar
                set count (math $count+1)
            else
                set newvar $newvar $v
            end
        end
        set $argv $newvar
        #test $count -gt 0
        #and echo Removed $count duplicates from $argv
    else
        for a in $argv
            dedup $a
        end
    end
end
