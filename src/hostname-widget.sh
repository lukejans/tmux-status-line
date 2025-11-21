#!/bin/sh

show_hostname=$(tmux show-option -gv @tmux-status-line_show_hostname)
if [ "${show_hostname}" -ne 1 ]; then
    exit 0
fi

if [ "$(uname)" = "Darwin" ]; then
    hostname=$(scutil --get HostName)
elif [ "$(uname)" = "Linux" ]; then
    hostname=$(hostnamectl hostname)
elif command -v hostname >/dev/null 2>&1; then
    hostname=$(hostname)
fi

echo "#[nodim,fg=#{@tmux-status-line_color_black}]@${hostname}"
