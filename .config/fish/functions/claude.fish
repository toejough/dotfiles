function claude --wraps=claude --description "Run claude, breaking out of split panes into own window"
    if set -q TMUX
        set -l pane_index (tmux display-message -p '#{pane_index}')
        set -l pane_count (tmux list-panes -F x | count)
        if test "$pane_index" != 0 -a $pane_count -gt 1
            tmux break-pane
        end

        # Name the window [team][agent] if launched as a team agent
        set -l team ""
        set -l agent ""
        set -l i 1
        while test $i -le (count $argv)
            switch $argv[$i]
                case --team-name
                    set i (math $i + 1)
                    set team $argv[$i]
                case --agent-name
                    set i (math $i + 1)
                    set agent $argv[$i]
            end
            set i (math $i + 1)
        end
        if test -n "$team" -a -n "$agent"
            tmux rename-window "[$team][$agent]"
        end
    end
    command claude $argv
end
