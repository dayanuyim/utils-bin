#!/bin/bash


if uname -a | grep -q Darwin; then
    dev=/Volumes/GARMIN
else
    dev=/media/$USER/GARMIN
fi

dst=$(date +'%Y%m%d')

mkdir -p "$dst" && cd "$dst" || exit 1

mkdir -p photo && mv $dev/DCIM/1000GRMN/* photo/
mv $dev/Garmin/GPX/航點_*.gpx .
mv $dev/Garmin/GPX/Archive/*.gpx .
cp $dev/Garmin/GPX/Current/*.gpx .
