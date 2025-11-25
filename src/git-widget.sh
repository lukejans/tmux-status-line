#!/bin/sh

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
git_repo="$1"
show_widget=$(tmux show -gv @tmux-status-line_show_git 2>/dev/null)

if ! cd "${git_repo}" 2>/dev/null \
    || ! git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
    || [ "${show_widget:-0}" -eq 0 ]; then
    exit 0
fi

# Git Icons
# ---------
icon_change=" "
icon_insert=" "
icon_delete=" "
icon_untracked=" "
icon_moved=" "
icon_unmerged=" "
icon_stash=" "
icon_clean="󰜝 "
icon_dirty="󰜞 "
icon_push=" "
icon_pull=" "
icon_diverged=" "

# Git Data
# --------
git_data=$(git status --porcelain=v2 --branch --show-stash 2>/dev/null)

IFS=' ' read -r branch ahead behind changes moved untracked stash unmerged <<EOF
$(printf "%s\n" "$git_data" | awk -f "$SCRIPT_DIR/parsers/git-status.awk")
EOF

if [ "$changes" -ne 0 ]; then
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

if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
    sync_mode="diverged"
elif [ "$ahead" -gt 0 ]; then
    sync_mode="ahead"
elif [ "$behind" -gt 0 ]; then
    sync_mode="behind"
elif [ "$changes" -gt 0 ] || [ "$moved" -gt 0 ] || [ "$untracked" -gt 0 ]; then
    sync_mode="dirty"
else
    sync_mode="clean"
fi

# Update Status Line
# ------------------
branch_status="#{@tmux-status-line_reset_style}"

if [ "$sync_mode" = 'dirty' ]; then
    branch_status="$branch_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_magenta},bold]${icon_dirty}"
elif [ "$sync_mode" = 'ahead' ]; then
    branch_status="$branch_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_red},bold]${icon_push}"
elif [ "$sync_mode" = 'behind' ]; then
    branch_status="$branch_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_red},bold]${icon_pull}"
elif [ "$sync_mode" = 'diverged' ]; then
    branch_status="$branch_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_red},bold]${icon_diverged}"
else
    branch_status="$branch_status#[bg=#{@tmux-status-line_color_bg},fg=#{@tmux-status-line_color_green},bold]${icon_clean}"
fi

if [ "${stash:-0}" -gt 0 ]; then
    stash_status="$icon_stash$stash"
fi

output="${stash_status:-} $branch_status#{@tmux-status-line_reset_style}${branch:-} "

if [ "${changes:-0}" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_yellow},bg=#{@tmux-status-line_color_bg},bold]${icon_change}${changes} "
fi

if [ "${insertions:-0}" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_green},bg=#{@tmux-status-line_color_bg},bold]${icon_insert}${insertions} "
fi

if [ "${deletions:-0}" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_red},bg=#{@tmux-status-line_color_bg},bold]${icon_delete}${deletions} "
fi

if [ "${untracked:-0}" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_brightblack},bg=#{@tmux-status-line_color_bg},bold]${icon_untracked}${untracked} "
fi

if [ "${moved:-0}" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_white},bg=#{@tmux-status-line_color_bg},bold]${icon_moved}${moved} "
fi

if [ "${unmerged:-0}" -gt 0 ]; then
    output="$output#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_white},bg=#{@tmux-status-line_color_bg},bold]${icon_unmerged}${unmerged} "
fi

echo "$output"
