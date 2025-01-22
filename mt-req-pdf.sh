#!/bin/bash

function usage_exit {
    echo >&2 "usage: ${0##*/} [入山許可證.pdf] [入山人員名冊.pdf]"
    exit 1
}

cert="${1:-入山許可證.pdf}"
crew="${2:-入山人員名冊.pdf}"
crew2="${crew%.pdf}2.pdf"
output="${cert%.pdf}_${crew}"

if [ ! -f "$cert" ]; then echo "cert file '$cert' does not exist." >&2; usage_exit; fi
if [ ! -f "$crew" ]; then echo "crew file '$crew' does not exist." >&2; usage_exit; fi

pdfjam "$crew" "$crew" --nup 1x2 --outfile "$crew2"

n="$(pdftk "$cert" dump_data | grep NumberOfPages | awk '{print $NF}')"

{
    echo -n "pdftk A='$cert' B='$crew2' cat "
    for i in $(seq "$n"); do
        echo -n "A$i B "
    done
    echo -n "output $output"
} | bash -x

rm "$crew2"
