#!/usr/bin/env bash

# Tmux Get Option:
#
# this attempts to get a value that was set in tmux configuration
# file. If the value is successfully retrieved, it is returned so
# it can be used. Otherwise, the fallback value is returned.
#
# $1 - option name
# $2 - fallback value
# stdout -> option or fallback value
#
tmux_get_opt() {
    local opt="$1"
    local fallback="${2:-}"
    if command -v tmux >/dev/null 2>&1; then
        local val
        val="$(tmux show-option -gv "${opt}" 2>/dev/null || true)"
        if [ -n "${val}" ]; then
            printf '%s' "${val}"
            return 0
        fi
    fi
    printf '%s' "${fallback}"
    return 0
}

# Color Theme
# ===========
declare -A THEME=()
# base colors
THEME[foreground]="$(tmux_get_opt @tmux-status-line_color_fg "default")"
THEME[background]="$(tmux_get_opt @tmux-status-line_color_bg "default")"
# regular colors
THEME[black]="$(tmux_get_opt @tmux-status-line_color_black "black")"
THEME[red]="$(tmux_get_opt @tmux-status-line_color_red "red")"
THEME[green]="$(tmux_get_opt @tmux-status-line_color_green "green")"
THEME[yellow]="$(tmux_get_opt @tmux-status-line_color_yellow "yellow")"
THEME[blue]="$(tmux_get_opt @tmux-status-line_color_blue "blue")"
THEME[magenta]="$(tmux_get_opt @tmux-status-line_color_magenta "magenta")"
THEME[cyan]="$(tmux_get_opt @tmux-status-line_color_cyan "cyan")"
THEME[white]="$(tmux_get_opt @tmux-status-line_color_white "white")"
# bright colors
THEME[brightblack]="$(tmux_get_opt @tmux-status-line_color_brightblack "brightblack")"
THEME[brightred]="$(tmux_get_opt @tmux-status-line_color_brightred "brightred")"
THEME[brightgreen]="$(tmux_get_opt @tmux-status-line_color_brightgreen "brightgreen")"
THEME[brightyellow]="$(tmux_get_opt @tmux-status-line_color_brightyellow "brightyellow")"
THEME[brightblue]="$(tmux_get_opt @tmux-status-line_color_brightblue "brightblue")"
THEME[brightmagenta]="$(tmux_get_opt @tmux-status-line_color_brightmagenta "brightmagenta")"
THEME[brightcyan]="$(tmux_get_opt @tmux-status-line_color_brightcyan "brightcyan")"
THEME[brightwhite]="$(tmux_get_opt @tmux-status-line_color_brightwhite "brightwhite")"
# status colors
THEME[status_left_bg]="$(tmux_get_opt @tmux-status-line_color_status_left_bg "reverse")"
# git colors
THEME[git_additions]="$(tmux_get_opt @tmux-status-line_color_git_additions "${THEME[green]}")"
THEME[git_deletions]="$(tmux_get_opt @tmux-status-line_color_git_deletions "${THEME[red]}")"
THEME[git_changes]="$(tmux_get_opt @tmux-status-line_color_git_changes "${THEME[yellow]}")"
THEME[git_untracked]="$(tmux_get_opt @tmux-status-line_color_git_untracked "${THEME[br]}")"
# github colors
THEME[gh_pr_clean]="$(tmux_get_opt @tmux-status-line_color_gh_pr "${THEME[green]}")"
THEME[gh_review]="$(tmux_get_opt @tmux-status-line_color_gh_review "${THEME[yellow]}")"
THEME[gh_issue]="$(tmux_get_opt @tmux-status-line_color_gh_issue "${THEME[green]}")"
THEME[gh_bug]="$(tmux_get_opt @tmux-status-line_color_gh_bug "${THEME[red]}")"
# netspeed colors
THEME[net_down]="$(tmux_get_opt @tmux-status-line_color_net_down "${THEME[cyan]}")"
THEME[net_up]="$(tmux_get_opt @tmux-status-line_color_net_up "${THEME[blue]}")"
THEME[net_iface]="$(tmux_get_opt @tmux-status-line_color_net_iface "${THEME[white]}")"

# Reset Style
# ===========
RESET="#[fg=${THEME[foreground]},bg=${THEME[background]},nobold,noitalics,nounderscore,nodim]"
