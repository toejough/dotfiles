function fish_prompt
    set -l last_status $status

    set -l current_dir (pwd)
    if test $last_dir != $current_dir
        set dir_text (set_color normal)"| PWD: "(set_color blue)"$current_dir "
        set -U last_dir $current_dir
    else
        set dir_text ""
    end

    if test $last_status -eq 0
        set rc_text "RC: "(set_color green)"$last_status "
    else
        set rc_text "RC: "(set_color red)"$last_status "
    end

    echo "$rc_text$dir_text"(set_color normal)"> "
end
