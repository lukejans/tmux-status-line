#!/usr/bin/env bash

index="$1"
format_opt="${2:-none}"

if [ "$format_opt" = "hide" ]; then
    exit 0
fi

declare -A format_opts=(
    [digital]="🯰🯱🯲🯳🯴🯵🯶🯷🯸🯹"
    [fsquare]="󰎡󰎤󰎧󰎪󰎭󰎱󰎳󰎶󰎹󰎼"
    [hsquare]="󰎣󰎦󰎩󰎬󰎮󰎰󰎵󰎸󰎻󰎾"
    [dsquare]="󰎢󰎥󰎨󰎫󰎲󰎯󰎴󰎷󰎺󰎽"
)

if [ "$format_opt" = "none" ]; then
    printf "%s " "$index"
elif [ -z "${format_opts[${format_opt}]}" ]; then
    tmux display-message "Invalid format option $format_opt"
    exit 1
else
    for ((i = 0; i < ${#index}; i++)); do
        digit=${index:i:1}
        printf "%s" "${format_opts[${format_opt}]:digit:1} "
    done
fi

exit 0
