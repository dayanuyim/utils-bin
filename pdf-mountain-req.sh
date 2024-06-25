#!/bin/bash

cert="$1"
crew="$2"
crew2="${crew%.pdf}-2.pdf"
output="${cert%.pdf}_$(basename "$crew")"

if [[ -z "$cert" || -z "$crew" ]]; then
    echo >&2 "usage: ${0##*/} <入山許可證.pdf> <入山人員名冊.pdf>"
    exit 1;
fi

if [[ ! -f "$cert" ]]; then
    echo >&2 "file '$cert' does not exist."
    exit 2
fi

if [[ ! -f "$crew" ]]; then
    echo >&2 "file '$crew' does not exist."
    exit 2
fi

pdfjam "$crew" "$crew" --nup 1x2 --outfile "$crew2"

n="$(pdftk "$cert" dump_data | grep NumberOfPages | awk '{print $2}')"

pages=
for i in $(seq "$n"); do
    pages="$pages A$i B"
done

pdftk A="$cert" B="$crew2" cat $pages output "$output"


rm "$crew2"
