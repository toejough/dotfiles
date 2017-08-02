function fish_prompt
	#function _old_fish_prompt
	#function fish_prompt --description 'Write out the prompt'
	set laststatus $status
    set git_name (git name ^/dev/null)
    if [ "$git_name" ]
        set git_block (set_color normal)"Branch: "(set_color -o white)$git_name

        set git_upstream_name (git upstream ^/dev/null)
        if [ "$git_upstream_name" ]
            set git_remote (set_color normal)"Remote: $git_upstream_name ("

            if git branch --remote | grep "$git_upstream_name" > /dev/null
                # ahead/behind
                set git_num_ahead (git rev-list "@{u}".. | wc -l | awk '{print $1}')
                set git_num_behind (git rev-list .."@{u}" | wc -l | awk '{print $1}')

                if [ (math "$git_num_ahead + $git_num_behind") = "0" ]
                    set git_remote "$git_remote"(set_color green)"="
                end
                # swapping behind/ahead because we're commenting on the state of remote, but
                # the normal git terms are in terms of local.
                if [ "$git_num_ahead" != "0" ]
                    set git_remote "$git_remote"(set_color yellow)"behind $git_num_ahead"
                end
                if [ "$git_num_behind" != "0" ]
                    if [ "$git_num_ahead" != "0" ]
                        set git_remote "$git_remote"(set_color normal)", "
                    end
                    set git_remote "$git_remote"(set_color red)"ahead $git_num_behind"
                end
            else
                set git_remote "$git_remote"(set_color -o red)"MISSING"
            end

            set git_remote "$git_remote"(set_color normal)")"
            set git_block "$git_block"\n"$git_remote"
        end

        # untracked
        set git_num_untracked (git status --porcelain | grep '^??' | wc -l | awk '{print $1}')
        if [ "$git_num_untracked" != "0" ]
            set git_block "$git_block"\n(set_color yellow)"$git_num_untracked untracked files"(set_color normal)
        end

        # staged changes
        set git_num_modified_staged (git status --porcelain | grep '^M' | wc -l | awk '{print $1}')
        set git_num_added_staged (git status --porcelain | grep '^A' | wc -l | awk '{print $1}')
        set git_num_deleted_staged (git status --porcelain | grep '^D' | wc -l | awk '{print $1}')
        set git_num_renamed_staged (git status --porcelain | grep '^R' | wc -l | awk '{print $1}')
        set git_num_copied_staged (git status --porcelain | grep '^C' | wc -l | awk '{print $1}')
        set git_num_updated_staged (git status --porcelain | grep '^U' | wc -l | awk '{print $1}')
        set git_staged (set_color -o green)"Staged:"
        set original_git_staged "$git_staged"
        if [ "$git_num_modified_staged" != "0" ]
            set git_staged "$git_staged"\n(set_color yellow)"  $git_num_modified_staged modified"
        end
        if [ "$git_num_added_staged" != "0" ]
            set git_staged "$git_staged"\n(set_color green)"  $git_num_added_staged added"
        end
        if [ "$git_num_deleted_staged" != "0" ]
            set git_staged "$git_staged"\n(set_color red)"  $git_num_deleted_staged deleted"
        end
        if [ "$git_num_renamed_staged" != "0" ]
            set git_staged "$git_staged"\n(set_color blue)"  $git_num_renamed_staged renamed"
        end
        if [ "$git_num_copied_staged" != "0" ]
            set git_staged "$git_staged"\n(set_color green)"  $git_num_copied_staged copied"
        end
        if [ "$git_num_updated_staged" != "0" ]
            set git_staged "$git_staged"\n(set_color red)"  $git_num_updated_staged 'updated'"
        end
        if [ "$git_staged" != "$original_git_staged" ]
            set git_staged "$git_staged"(set_color normal)
            set git_block "$git_block"\n"$git_staged"
        end

        ## unstaged changes
        set git_num_modified_unstaged (git status --porcelain | grep '^.M' | wc -l | awk '{print $1}')
        set git_num_added_unstaged (git status --porcelain | grep '^.A' | wc -l | awk '{print $1}')
        set git_num_deleted_unstaged (git status --porcelain | grep '^.D' | wc -l | awk '{print $1}')
        set git_num_renamed_unstaged (git status --porcelain | grep '^.R' | wc -l | awk '{print $1}')
        set git_num_copied_unstaged (git status --porcelain | grep '^.C' | wc -l | awk '{print $1}')
        set git_num_updated_unstaged (git status --porcelain | grep '^.U' | wc -l | awk '{print $1}')
        set git_unstaged (set_color -o red)"Unstaged:"
        set original_git_unstaged "$git_unstaged"
        if [ "$git_num_modified_unstaged" != "0" ]
            set git_unstaged "$git_unstaged"\n(set_color yellow)"  $git_num_modified_unstaged modified"
        end
        if [ "$git_num_added_unstaged" != "0" ]
            set git_unstaged "$git_unstaged"\n(set_color green)"  $git_num_added_unstaged added"
        end
        if [ "$git_num_deleted_unstaged" != "0" ]
            set git_unstaged "$git_unstaged"\n(set_color red)"  $git_num_deleted_unstaged deleted"
        end
        if [ "$git_num_renamed_unstaged" != "0" ]
            set git_unstaged "$git_unstaged"\n(set_color blue)"  $git_num_renamed_unstaged renamed"
        end
        if [ "$git_num_copied_unstaged" != "0" ]
            set git_unstaged "$git_unstaged"\n(set_color green)"  $git_num_copied_unstaged copied"
        end
        if [ "$git_num_updated_unstaged" != "0" ]
            set git_unstaged "$git_unstaged"\n(set_color red)"  $git_num_updated_unstaged 'updated'"
        end
        if [ "$git_unstaged" != "$original_git_unstaged" ]
            set git_unstaged "$git_unstaged"(set_color normal)
            set git_block "$git_block"\n"$git_unstaged"
        end
    end

    # python
    set python_version (python --version ^&1)
    set python_block (set_color -o green)"$python_version"
    set python_venv (basename $VIRTUAL_ENV ^ /dev/null)
    if [ "$python_venv" ]
        set python_block "$python_block"\n(set_color normal)"Virtual Env: "(set_color yellow)"$python_venv"
    end

    # main block
    set directory (set_color yellow)(echo $PWD | sed -e "s|^$HOME|~|")
    set info_block $directory

    if [ "$git_block" ]
        set info_block "$info_block"\n"$git_block"
    end

    if [ "$python_block" ]
        set info_block "$info_block"\n"$python_block"
    end
    
    if [ "$info_block" != "$current_info_block" ]
        printf "\n%s\n" $info_block
        set -U current_info_block "$info_block"
    end

    if test $laststatus -eq 0
        printf "%s>%s " (set_color -o green) (set_color normal)
    else
        printf "%s%s>%s " (set_color -o red) $laststatus (set_color normal)
    end

    # iterm
    if type -q it2setkeylabel
        it2setkeylabel set status (string match -r '^\S+' (pyenv version))
    end
    if functions -q -- iterm2_print_user_vars
      iterm2_print_user_vars
    end
end
