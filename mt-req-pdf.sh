#!/bin/bash

function usage_exit {
    echo >&2 "usage: ${0##*/} [入山許可證.pdf] [入山人員名冊.pdf]"
    exit 1
}

cert="${1:-入山許可證.pdf}"
crew="${2:-入山人員名冊.pdf}"
crew2="${crew%.pdf}w.pdf"
output="${cert%.pdf}_${crew}"

if [ ! -f "$cert" ]; then echo "cert file '$cert' does not exist." >&2; usage_exit; fi
if [ ! -f "$crew" ]; then echo "crew file '$crew' does not exist." >&2; usage_exit; fi

pdfjam "$crew" "$crew" --nup 1x2 --outfile "$crew2"

n="$(pdftk "$cert" dump_data | grep NumberOfPages | awk '{print $NF}')"

#pdftk A="$cert" B="$crew2" cat $(eval echo A{1..$n}\\ B) output $output verbose
pdftk A="$cert" B="$crew2" cat $(printf "A%s B " $(seq 1 "$n")) output $output verbose

rm "$crew2"
