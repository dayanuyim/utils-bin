#!/bin/bash

usage_exit() {
    echo >&2 "usage: ${0##*/} <pdf> <begin-page-number>"
    exit 9
}

pdf="$1"
begin="$2"

if [[ -z "$1" || -z "$2" ]]; then
    usage_exit
fi

tmp="/tmp/booklet-tmp-$RANDOM.pdf"

pdftk "$pdf" cat \
    "$((begin))"     "$((begin + 2))" "$((begin + 4))" "$((begin + 6))" \
    "$((begin + 3))" "$((begin + 1))" "$((begin + 7))" "$((begin + 5))" \
    output "$tmp"

pdfjam "$tmp" --nup 2x2 --outfile "${pdf%.pdf}-booklet-$begin-$((begin+7)).pdf"

rm "$tmp"

#pdfjam "$crew" "$crew" --nup 1x2 --outfile "$crew2"
#
#n="$(pdftk "$cert" dump_data | grep NumberOfPages | awk '{print $2}')"
#
#{
#    echo -n "pdftk A='$cert' B='$crew2' cat "
#    for i in $(seq $n); do
#        echo -n "A$i B "
#    done
#    echo -n "output $output"
#} | bash -x
#
#rm "$crew2"
