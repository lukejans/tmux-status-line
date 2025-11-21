#!/usr/bin/env bash

show_widget=$(tmux show-option -gv @tmux-status-line_show_web_git)

if [ "$show_widget" == "0" ]; then
    exit 0
fi

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/coreutils-compat.sh"

cd "$1" || exit 1
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
provider=$(git config remote.origin.url | awk -F '@|:' '{print $2}')

icon_github=" "
icon_gitlab=" "
icon_provider=""
icon_issue=" "
icon_pr=" "
icon_review=" "
icon_bug=" "
icon_web_status=" "

pr_count=0
review_count=0
issue_count=0
bug_count=0

pr_status=""
review_status=""
issue_status=""
bug_status=""

if [[ -z $branch ]]; then
    exit 0
fi

if [[ $provider == "github.com" ]]; then
    if ! command -v gh &>/dev/null; then
        exit 1
    fi
    icon_provider="#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_fg}]${icon_github}"
    pr_count=$(gh pr list --json number --jq 'length' | bc)
    review_count=$(gh pr status --json reviewRequests --jq '.needsReview | length' | bc)
    RES=$(gh issue list --json "assignees,labels" --assignee @me)
    issue_count=$(echo "$RES" | jq 'length' | bc)
    bug_count=$(echo "$RES" | jq 'map(select(.labels[].name == "bug")) | length' | bc)
    issue_count=$((issue_count - bug_count))
elif [[ $provider == "gitlab.com" ]]; then
    if ! command -v glab &>/dev/null; then
        exit 1
    fi
    icon_provider="#{@tmux-status-line_reset_style}#[fg=#fc6d26]${icon_gitlab}"
    pr_count=$(glab mr list | grep -cE "^\!")
    review_count=$(glab mr list --reviewer=@me | grep -cE "^\!")
    issue_count=$(glab issue list | grep -cE "^\#")
else
    exit 0
fi

if [[ $pr_count -gt 0 ]]; then
    pr_status="#[fg=#{@tmux-status-line_color_green},bg=#{@tmux-status-line_color_bg},bold]${icon_pr}#{@tmux-status-line_reset_style}${pr_count} "
fi

if [[ $review_count -gt 0 ]]; then
    review_status="#[fg=#{@tmux-status-line_color_yellow},bg=#{@tmux-status-line_color_bg},bold]${icon_review}#{@tmux-status-line_reset_style}${review_count} "
fi

if [[ $issue_count -gt 0 ]]; then
    issue_status="#[fg=#{@tmux-status-line_color_green},bg=#{@tmux-status-line_color_bg},bold]${icon_issue}#{@tmux-status-line_reset_style}${issue_count} "
fi

if [[ $bug_count -gt 0 ]]; then
    bug_status="#[fg=#{@tmux-status-line_color_red},bg=#{@tmux-status-line_color_bg},bold]${icon_bug}#{@tmux-status-line_reset_style}${bug_count} "
fi

wb_status="#[fg=#{@tmux-status-line_color_black},bg=#{@tmux-status-line_color_bg},bold]${icon_web_status}#{@tmux-status-line_reset_style}$icon_provider $reset$pr_status$review_status$issue_status$bug_status"

echo "$wb_status"

# don't overload Web APIs (20s sleep minimum)
interval=$(tmux display -p '#{status-interval}')
if [[ $interval -lt 20 ]]; then
    sleep 20
fi
