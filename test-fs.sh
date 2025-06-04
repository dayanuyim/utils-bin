#!/bin/bash

path="${1%/}"
if [[ -z "$path" ]]; then
    echo >&2 "usage: ${0##*/} <LocationPath>"
    exit 9
fi

tmp="$path/_test_$RANDOM"

echo >&2 -n "Write Test: "
if touch "$tmp" && ls "$tmp" >/dev/null; then
    echo >&2 "OK"
else
    echo >&2 "Fail"
    exit 1
fi

echo >&2 -n "Delete Test: "
if rm "$tmp" && ! ls -l "$tmp" 2>/dev/null; then
    echo >&2 "OK"
else
    echo >&2 "Fail"
    exit 2
fi
