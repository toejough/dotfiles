#! /usr/bin/env fish
# Replay tide configuration — Solarized Dark, Rainbow style, two-line prompt (no frame)
# Run this after `fisher install IlanCosman/tide` on a fresh machine.

tide configure \
    --auto \
    --style=Rainbow \
    --prompt_colors='True color' \
    --show_time='12-hour format' \
    --rainbow_prompt_separators=Round \
    --powerline_prompt_heads=Round \
    --powerline_prompt_tails=Round \
    --powerline_prompt_style='Two lines, character' \
    --prompt_connection=Dotted \
    --powerline_right_prompt_frame=No \
    --prompt_connection_andor_frame_color=Darkest \
    --prompt_spacing=Sparse \
    --icons='Many icons' \
    --transient=No

# Override colors to match Solarized Dark
# (tide configure picks its own rainbow palette; these fix it)
set -U tide_aws_bg_color FF9900
set -U tide_aws_color 232F3E
set -U tide_character_color 859900
set -U tide_character_color_failure dc322f
set -U tide_cmd_duration_bg_color b58900
set -U tide_cmd_duration_color 002b36
set -U tide_context_bg_color 073642
set -U tide_context_color_default 839496
set -U tide_context_color_root b58900
set -U tide_context_color_ssh 2aa198
set -U tide_git_bg_color 859900
set -U tide_git_bg_color_unstable b58900
set -U tide_git_bg_color_urgent dc322f
set -U tide_git_color_branch 002b36
set -U tide_git_color_conflicted 002b36
set -U tide_git_color_dirty 002b36
set -U tide_git_color_operation 002b36
set -U tide_git_color_staged 002b36
set -U tide_git_color_stash 002b36
set -U tide_git_color_untracked 002b36
set -U tide_git_color_upstream 002b36
set -U tide_go_bg_color 2aa198
set -U tide_go_color 002b36
set -U tide_java_bg_color cb4b16
set -U tide_java_color 002b36
set -U tide_jobs_bg_color 073642
set -U tide_jobs_color 859900
set -U tide_node_bg_color 859900
set -U tide_node_color 002b36
set -U tide_os_bg_color 073642
set -U tide_os_color 839496
set -U tide_prompt_color_frame_and_connection 586e75
set -U tide_prompt_color_separator_same_color 657b83
set -U tide_pwd_bg_color 268bd2
set -U tide_pwd_color_anchors fdf6e3
set -U tide_pwd_color_dirs eee8d5
set -U tide_pwd_color_truncated_dirs 839496
set -U tide_python_bg_color 268bd2
set -U tide_python_color fdf6e3
set -U tide_status_bg_color 073642
set -U tide_status_bg_color_failure dc322f
set -U tide_status_color 859900
set -U tide_status_color_failure fdf6e3
set -U tide_time_bg_color 073642
set -U tide_time_color 839496
set -U tide_vi_mode_bg_color_default 586e75
set -U tide_vi_mode_bg_color_insert 268bd2
set -U tide_vi_mode_bg_color_replace cb4b16
set -U tide_vi_mode_bg_color_visual d33682
set -U tide_vi_mode_color_default fdf6e3
set -U tide_vi_mode_color_insert 002b36
set -U tide_vi_mode_color_replace 002b36
set -U tide_vi_mode_color_visual 002b36
