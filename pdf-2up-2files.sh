#!/usr/bin/env bash

tmpdir=/tmp/tmp.$RANDOM
mkdir -p "$tmpdir"
trap 'rm -rf "$tmpdir"' EXIT

usage_exit() {
    echo >&2 "usage: ${0##*/} [plan.pdf] [food.pdf]"
    exit 1
}

nupfile() {

    local f="$1"
    local fw="$tmpdir/$f"

    if [ ! -f "$f" ]; then
        echo  >&2 "error: the file '$f' does not exist."
        usage_exit;
    fi

    pdfjam "$f" "$f" --nup 1x2 --outfile "$fw" >&2
    echo "$fw"
}

f1="${1:-plan.pdf}"
f2="${2:-food.pdf}"
output="${f1%.pdf}_${f2}"


pdfjam "$(nupfile "$f1")" "$(nupfile "$f2")" --outfile "$output"
set -x
