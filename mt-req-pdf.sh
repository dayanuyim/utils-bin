#!/bin/bash

cert=入山許可證.pdf
crew=入山人員名冊.pdf
crew2="${crew%.pdf}2.pdf"
output=入山許可證_名冊.pdf

if [ ! -f "$cert" ]; then echo "file '$cert' does not exist." >&2; exit 1 ; fi
if [ ! -f "$crew" ]; then echo "file '$crew' does not exist." >&2; exit 1 ; fi

pdfjam "$crew" "$crew" --nup 1x2 --outfile "$crew2"

n="$(pdftk "$cert" dump_data | grep NumberOfPages | awk '{print $2}')"

{
    echo -n "pdftk A='$cert' B='$crew2' cat "
    for i in $(seq $n); do
        echo -n "A$i B "
    done
    echo -n "output $output"
} | bash -x

rm "$crew2"
