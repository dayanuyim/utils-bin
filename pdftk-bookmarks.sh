#!/usr/bin/env bash

srcpdf="$1"
dstpdf="$2"

pdftk "$srcpdf" \
    update_info bookmarks.txt \
    output "$dstpdf"
