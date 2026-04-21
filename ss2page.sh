#!/usr/bin/env bash


fprefix="eng-"
fprefix=""

#for((i = 1; ; i++)); do
#    fbase="${fprefix}${i}"
#    if [[ ! -e "${fbase}A.png" ]]; then
#        break
#    fi
#done

n=$(ls | gsed -n 's/^'$fprefix'\([0-9]\+\)A.png$/\1/p' | sort -unr | head -n1)
if [[ -z "$n" ]]; then
    n=1
else
    n=$((10#$n + 1))  # force to base 10
fi

fbase="$fprefix$(printf "%02d" $n)"

screencapture -D2 "$fbase.png" || exit 9
magick "$fbase.png" -crop 50%x100% +repage "$fbase-%d.png"
rm "$fbase.png"
mv "$fbase-0.png" "${fbase}A.png"
mv "$fbase-1.png" "${fbase}B.png"
