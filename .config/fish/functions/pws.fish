function pws --description "Present working status: PWD, repo status, directory listing"
    echo (set_color cyan)"PWD: "(set_color blue)(pwd)(set_color normal)

    # git status (if in git repo)
    if git rev-parse --git-dir >/dev/null 2>&1
        if git config --get remote.(git remote 2>/dev/null).url >/dev/null 2>&1
            echo (set_color cyan)"GIT REMOTE: "(set_color normal)(git config --get remote.(git remote).url)
        end
        if test -n "(git status --porcelain)"
            echo -n (set_color cyan)"GIT STATUS: "(set_color normal)
            git status -sb
        end
    end

    # jj status (if in jj repo)
    if jj root >/dev/null 2>&1
        echo -n (set_color cyan)"JJ STATUS: "(set_color normal)
        jj status
    end

    lt
end
