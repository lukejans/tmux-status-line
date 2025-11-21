#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
script_path="${current_dir}/src"

option_prefix="@tmux-status-line_"

tmux_opt_setup() {
    local option_name="${option_prefix}${1}"
    local option_default="${2}"
    tmux set-option -go "${option_name}" "${option_default}"
}

# Theme
# -----
term_icon=""
term_icon_active=""
ssh_icon=""
last_win_icon="󰁯"
prefix_active="󰠠"
prefix_idle="󰤂"
# base colors
tmux_opt_setup "color_fg" "default"
tmux_opt_setup "color_bg" "default"
# regular colors
tmux_opt_setup "color_black" "black"
tmux_opt_setup "color_red" "red"
tmux_opt_setup "color_green" "green"
tmux_opt_setup "color_yellow" "yellow"
tmux_opt_setup "color_blue" "blue"
tmux_opt_setup "color_magenta" "magenta"
tmux_opt_setup "color_cyan" "cyan"
tmux_opt_setup "color_white" "white"
# bright colors
tmux_opt_setup "color_brightblack" "brightblack"
tmux_opt_setup "color_brightred" "brightred"
tmux_opt_setup "color_brightgreen" "brightgreen"
tmux_opt_setup "color_brightyellow" "brightyellow"
tmux_opt_setup "color_brightblue" "brightblue"
tmux_opt_setup "color_brightmagenta" "brightmagenta"
tmux_opt_setup "color_brightcyan" "brightcyan"
tmux_opt_setup "color_brightwhite" "brightwhite"
# reset style
tmux_opt_setup "reset_style" "#[fg=#{@tmux-status-line_color_fg},bg=#{@tmux-status-line_color_bg},nobold,noitalics,nounderscore,nodim]"

# Tmux Options
# ------------
tmux set -g status-left-length 80
tmux set -g status-right-length 150
tmux set -g status-style bg="#{@tmux-status-line_color_bg}"
tmux set -g message-style "bg=#{@tmux-status-line_color_blue},fg=#{@tmux-status-line_color_fg}"
tmux set -g message-command-style "fg=#{@tmux-status-line_color_white},bg=#{@tmux-status-line_color_black}"

# Defaults
# --------
tmux_opt_setup "window_id_style" "hsquare"
tmux_opt_setup "pane_id_style" "hsquare"
tmux_opt_setup "zoom_id_style" "dsquare"

# Widget Calls
# ------------
hostname="#(${script_path}/hostname-widget.sh)"
git_status="#(${script_path}/git-widget.sh #{pane_current_path})"
wb_git_status="#(${script_path}/wb-git-widget.sh #{pane_current_path})"
window_number="#(${script_path}/custom-number.sh #{window_index} #{@tmux-status-line_window_id_style})"
custom_pane="#(${script_path}/custom-number.sh #{pane_index} #{@tmux-status-line_pane_id_style})"
zoom_number="#(${script_path}/custom-number.sh #{pane_index} #{@tmux-status-line_zoom_id_style})"
# date_and_time="#(${script_path}/datetime-widget.sh)"
# current_path="#(${script_path}/path-widget.sh #{pane_current_path})"
# netspeed="#(${script_path}/netspeed.sh)"
# battery_status="#(${script_path}/battery-widget.sh)"

# Status Line
# -----------
# left status line
tmux set -g status-left "#[fg=#{@tmux-status-line_color_fg},bg=#{@tmux-status-line_color_bg},reverse,bold] #{?client_prefix,${prefix_active} ,#[dim]${prefix_idle} }#[bold,nodim]#S${hostname} "
# window focused
tmux set -g window-status-current-format "#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_fg},bg=#{@tmux-status-line_color_brightblue},reverse] #{?#{==:#{pane_current_command},ssh},${ssh_icon} ,${term_icon_active} }#[fg=#{@tmux-status-line_color_fg},bg=#{@tmux-status-line_color_bg},bold,nodim]${window_number}#W#[nobold]#{?window_zoomed_flag, ${zoom_number}, ${custom_pane}}#{?window_last_flag, , }"
# window unfocused
tmux set -g window-status-format "#{@tmux-status-line_reset_style}#[fg=#{@tmux-status-line_color_fg}] #{?#{==:#{pane_current_command},ssh},${ssh_icon} ,${term_icon} }#{@tmux-status-line_reset_style}${window_number}#W#[nobold,dim]#{?window_zoomed_flag, ${zoom_number}, ${custom_pane}}#[fg=#{@tmux-status-line_color_brightyellow}]#{?window_last_flag,${last_win_icon}  , }"
# right status line
tmux set -g status-right "${git_status}${wb_git_status}"
# tmux set -g status-right "${battery_status}${current_path}${netspeed}${git_status}${wb_git_status}${date_and_time}"
tmux set -g window-status-separator ""
