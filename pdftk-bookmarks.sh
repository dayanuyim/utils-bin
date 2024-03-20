#!/usr/bin/env bash


pdf="$1"
bookmarks="$2"
if [ -z "$pdf" ]; then
    echo "usage: ${0##*/} <pdf> [bookmarks.txt]" >&2
    exit 1
fi

if [ ! -f "$pdf" ]; then
    echo "pdf not exists" >&2
    exit 2
fi

if [ -z "$bookmarks" ]; then
    bookmarks="$(dirname "$pdf")/pdftk-bookmarks.txt"
fi

if [ ! -f "$bookmarks" ]; then
    echo "bookmarks not exists" >&2
    exit 3
fi

orig="${pdf%.pdf}.orig.pdf"

mv "$pdf" "$orig" && \
    pdftk "$orig" update_info "$bookmarks" output "$pdf"
