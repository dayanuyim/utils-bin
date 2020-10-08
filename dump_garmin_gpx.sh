#!/bin/bash

$GARMIN_DEV=/Volumes/GARMIN

dir=$(date '+%Y-%m%d')
mkdir $dir && cd $dir

mkdir photo
mv $GARMIN_DEV/DCIM/1000GRMN/* photo/

mv $GARMIN_DEV/Garmin/GPX/航點_*.gpx .
mv $GARMIN_DEV/Garmin/GPX/Archive/* .
cp $GARMIN_DEV/Garmin/GPX/Current/* .
