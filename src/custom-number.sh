#!/usr/bin/env bash

# Imports
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
. "${ROOT_DIR}/lib/coreutils-compat.sh"

format_hide=""
format_none="0123456789"
format_digital="🯰🯱🯲🯳🯴🯵🯶🯷🯸🯹"
format_fsquare="󰎡󰎤󰎧󰎪󰎭󰎱󰎳󰎶󰎹󰎼"
format_hsquare="󰎣󰎦󰎩󰎬󰎮󰎰󰎵󰎸󰎻󰎾"
format_dsquare="󰎢󰎥󰎨󰎫󰎲󰎯󰎴󰎷󰎺󰎽"
format_super="⁰¹²³⁴⁵⁶⁷⁸⁹"
format_sub="₀₁₂₃₄₅₆₇₈₉"

ID=$1
FORMAT=${2:-none}

# preserve leading whitespace for bash
format="$(eval echo \"\$format_"${FORMAT}"\")"

if [ "${FORMAT}" = "hide" ]; then
    exit 0
fi

if [ -z "${format}" ]; then
    echo "Invalid format: ${FORMAT}"
    exit 1
fi

for ((i = 0; i < ${#ID}; i++)); do
    DIGIT=${ID:i:1}
    echo -n "${format:DIGIT:1} "
done
