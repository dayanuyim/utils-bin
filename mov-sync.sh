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
    echo >&2 "usage: ${0##*/} [dir]"
    exit 1
}

function lookup_subpath {
    local key="$1"
    local path

    if ! path="$(rg -N -F "$key" "$MOV_LST")"; then
        echo >&2 "error: no path for '$key'"
        exit 2
    fi

    if [[ $(wc -l <<< "$path") -gt 1 ]]; then
        echo >&2 "error: multiple pathes found:"
        gsed >&2 's/^/  /' <<< "$path"
        exit 2
    fi

    echo "$path"
}

srcdir="${1:-$PWD}"
dstdir="${PREFIXES[0]}/$(lookup_subpath "$(basename "$srcdir")")"

if [[ ! -d "$srcdir" ]]; then
    echo >&2 "error: the source dir does not exist: '$srcdir'"
    exit 3
fi

if [[ ! -d "$dstdir" ]]; then
    echo >&2 "error: the destination dir does not exist: '$dstdir'"
    exit 3
fi


echo >&2 "sync '$srcdir/' to '$dstdir/'"
rsync -avhP \
    --remove-source-files \
    --exclude='.*' \
    --exclude='.DS_Store' \
    "$srcdir"/ "$dstdir"/
