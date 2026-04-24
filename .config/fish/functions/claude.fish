function claude --wraps=claude --description "Run claude, naming the window for team agent sessions"
    if set -q TMUX
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
