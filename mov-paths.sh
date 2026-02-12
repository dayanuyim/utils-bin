#!/usr/bin/env bash

source "$HOME/bin/libs.sh"

PREFIXES=(
    /Volumes/bulk/Movie
    /Volumes/bulk
)
MOV_LST="$HOME/Dropbox/Doc_文件/movies.lst"

#================================================================================

function errmsg_exit {
    echo >&2 "$1"
    echo >&2 "usage: ${0##*/} keyword [-y]"
    exit 1
}

function sort_data {
    if [[ "$1" == "-y" ]]; then
        awk -F'.' '{print $NF,$0}' | sort -n | cut -d' ' -f2-
    else
        sort
    fi
}

keyword="$1"
orderby="$2"

if [[ -z "$keyword" ]]; then
    errmsg_exit "error: no keyword."
fi

prefix="${PREFIXES[0]}"

if [[ -t 1 ]];then
    prefix="${c_lightgray}${prefix}${c_end}"
    when=always
else
    when=never
fi


rg --no-line-number --color=$when -i "$keyword" "$MOV_LST" |
    xargs -I{} echo "$prefix/{}" |
    sort_data "$orderby"
