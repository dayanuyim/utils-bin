#!/bin/bash

function usage {
    echo "usage: ${0##*/} <dir> <min-free-disk>" >&2
}

function tobyte {
    case "$1" in
        *[kK]) echo $((1024 * ${1::-1}))
            ;;
        *[mM]) echo $((1024 * 1024 * ${1::-1}))
            ;;
        *[gG]) echo $((1024 * 1024 * 1024 * ${1::-1}))
            ;;
        *) echo "$1"
            ;;
    esac
}

function freedisk {
    kb=$(df | awk '$NF=="/" {print $4}')
    echo $((1024 * kb))
}

function oldest_file {
    #file="$(ls -t "$1" | tail -n1)"
    #echo "$1/$file"
    find "$1" -type f -printf '%T+\0%p\n' | sort | head -n1 | awk -F'\0' '{print $2}'
}


dir="${1%/}"
limit="$(tobyte "$2")"

if [[ -z "$dir" || -z "$limit" ]]; then
    usage
    exit 1
fi

while [ "$(freedisk)" -lt "$limit" ]; do
    # action
    file="$(oldest_file "$dir")"
    echo "deleting '$file'..."
    rm "$file"

    # wait fs sync
    sleep 1s
done

