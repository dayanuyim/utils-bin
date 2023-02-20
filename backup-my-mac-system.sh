#!/bin/bash

DST="/Volumes/TEAM/backup/mac"

SRCS="\
$HOME/Desktop \
$HOME/Documents \
$HOME/Downloads \
$HOME/Movies \
$HOME/Music \
$HOME/Pictures \
$HOME/Tests \
$HOME/Works \
$HOME/bin \
"

#du -cmd0 $SRCS

source "${0%/*}/libs.sh"

function backup {
    rsync -rl -ut -vP "$@" \
        --exclude='.DS_Store' \
        --exclude="*.photoslibrary" \
        --exclude=".git" \
        --exclude="node_modules/" \
        --exclude="debug/" \
        --exclude="target/" \
        --exclude="sessions/" \
        --exclude="*.mp4" \
        --exclude="*.mkv" \
        --exclude="$HOME/Documents/Books" \
        --delete --delete-excluded \
        $SRCS "$DST"
}

backup -n
if ask_yesno "To Copy"; then
    backup
fi



