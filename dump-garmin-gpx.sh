#!/bin/bash

dev=/media/$USER/GARMIN

dst=$(date +'%Y%m%d')

mkdir "$dst" && cd "$dst" || exit 1

mkdir photo && mv $dev/DCIM/1000GRMN/* photo/
mv $dev/Garmin/GPX/航點_*.gpx .
mv $dev/Garmin/GPX/Archive/*.gpx .
cp $dev/Garmin/GPX/Current/*.gpx .
