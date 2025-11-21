#!/bin/sh

set -u

git_repo="$1"
show_widget=$(tmux show -gv @tmux-status-line_show_git 2>/dev/null)

if ! cd "${git_repo}" 2>/dev/null \
    || [ ! -d .git ] \
    || [ "${show_widget:-0}" -eq 0 ]; then
    exit 0
fi

# Git Icons
# ---------
icon_change=" "
icon_insert=" "
icon_delete=" "
icon_untracked=" "
icon_move=" "
icon_clean="󰜝 "    # 󰘬 󱓏 
icon_dirty="󰜞 "    # 󱓎 󰜜 󰜛 󰜘
icon_push=" "     # 󱓊 󰜞
icon_pull=" "     # 󰓂  󰜚
icon_diverged=" " #  󰘭 󰘬 

# Git Data
# --------
git_data=$(git status --porcelain=v2 --branch 2>/dev/null | awk '
    BEGIN {
        files_changed = 0
        files_moved = 0
        files_untracked = 0
        repo_ahead = 0
        repo_behind = 0
        git_branch = ""
    }

    /^# branch.head/ { git_branch = $3 }
    /^# branch.ab/   {
        repo_ahead = substr($3, 2)
        repo_behind = substr($4, 2)
    }

    /^[12] / {
        status = $2
        if (status ~ /M/ || status ~ /D/) files_changed++
        if (status ~ /R/) files_moved++
    }

    /^\?/ { files_untracked++ }

    END {
        print files_changed, files_moved, files_untracked, repo_ahead, repo_behind, git_branch
    }
')

# shellcheck disable=SC2086
#
set -- $git_data
files_changed=$1
files_moved=$2
files_untracked=$3
repo_ahead=$4
repo_behind=$5
git_branch=$6
set --

if [ "$files_changed" -ne 0 ]; then
    git_diff=$(git diff --shortstat 2>/dev/null)

    insertions=$(
        printf "%s\n" "$git_diff" \
            | grep -o '[0-9]\{1,\} insertions' \
            | cut -d' ' -f1
    )
    deletions=$(
        printf "%s\n" "$git_diff" \
            | grep -o '[0-9]\{1,\} deletions' \
            | cut -d' ' -f1
    )

    insertions=${insertions:-0}
    deletions=${deletions:-0}
fi

# Branch Status
# -------------
[ -z "$git_branch" ] && exit 0

if [ "$git_branch" = "(detached)" ]; then
    short_sha=$(git rev-parse --short HEAD)
    git_branch="󰘦 $short_sha"
fi

if [ "${#git_branch}" -gt 25 ]; then
    git_branch="$(echo "$git_branch" | cut -c1-25)…"
fi

if [ "$repo_ahead" -gt 0 ] && [ "$repo_behind" -gt 0 ]; then
    sync_mode="diverged"
elif [ "$repo_ahead" -gt 0 ]; then
    sync_mode="ahead"
elif [ "$repo_behind" -gt 0 ]; then
    sync_mode="behind"
elif [ "$files_changed" -gt 0 ] || [ "$files_moved" -gt 0 ] || [ "$files_untracked" -gt 0 ]; then
    sync_mode="dirty"
else
    sync_mode="clean"
fi

# Update Status Line
# ------------------
remote_status="#{@tmux-status-line_reset_style}"

if [ "$sync_mode" = 'dirty' ]; then
    remote_status="$remote_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_magenta},bold]${icon_dirty}"
elif [ "$sync_mode" = 'ahead' ]; then
    remote_status="$remote_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_red},bold]${icon_push}"
elif [ "$sync_mode" = 'behind' ]; then
    remote_status="$remote_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_red},bold]${icon_pull}"
elif [ "$sync_mode" = 'diverged' ]; then
    remote_status="$remote_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_red},bold]${icon_diverged}"
else
    remote_status="$remote_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_green},bold]${icon_clean}"
fi

output="$remote_status#{@tmux-status-line_reset_style}${git_branch:-} "

if [ "$files_changed" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_yellow},bg=#{@tmux-status-line_color_bg},bold]${icon_change}${files_changed} "
fi

if [ "${insertions:-0}" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_green},bg=#{@tmux-status-line_color_bg},bold]${icon_insert}${insertions} "
fi

if [ "${deletions:-0}" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_red},bg=#{@tmux-status-line_color_bg},bold]${icon_delete}${deletions} "
fi

if [ "$files_untracked" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_brightblack},bg=#{@tmux-status-line_color_bg},bold]${icon_untracked}${files_untracked} "
fi

if [ "$files_moved" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_white},bg=#{@tmux-status-line_color_bg},bold]${icon_move}${files_moved} "
fi

echo "$output"
