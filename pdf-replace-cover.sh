#!/usr/bin/env bash


file="$1"
file_stem="${file%.pdf}"
file_orig="$file_stem.org.pdf"
file_info="$file_stem.info.txt"
file_1="$file_stem.1.pdf"
file_2="$file_stem.2.pdf"
file_3="$file_stem.3.pdf"

cover="$2"
cover_pages=1

if [[ ! -f "$file" ]]; then
    echo >&2 "no such file: '$file'"
    err=1
fi

if [[ ! -f "$cover" ]]; then
    echo >&2 "no such file: '$cover'"
    err=2
fi

if [[ -n "$err" ]]; then
    echo >&2 "usage: ${0##*/} FILE.pdf COVER.pdf"
    exit "$err"
fi

pdftk "$file" dump_data > "$file_info"
pdftk "$file" cat $((cover_pages+1))-end output "$file_1"
pdftk "$cover" "$file_1" cat output "$file_2"
pdftk "$file_2" update_info "$file_info" output "$file_3"

# swap the final output with the original, and
# clean the temperary files
mv "$file"  "$file_orig"
mv "$file_3" "$file"
rm "$file_info" "$file_1" "$file_2"
