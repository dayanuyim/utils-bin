#!/usr/bin/env bash

if ! uname -a | grep -q Darwin; then
    echo "Only for MAC"
    exit 1
fi    

# Delete TimeMachine Snapshots

for t in $(tmutil listlocalsnapshots / | tail -n+2 | cut -d"." -f4)
do
    tmutil deletelocalsnapshots "$t"
done
