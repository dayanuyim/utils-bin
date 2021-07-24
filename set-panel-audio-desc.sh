#!/bin/bash

function set_audio_desc {
    idx="$1"
    desc="$2"
    if [[ $1 -eq 0 ]]; then
        sn=""
    else
        sn=".$((idx+1))"
    fi
    pacmd "update-sink-proplist alsa_output.platform-bcm2835_audio.stereo-fallback$sn device.description='$desc'"
}

aplay --list-devices | grep '^card' | sed 's/card \([0-9]\):.*\[\(.*\)\]/\1:\2/' | \
    while read -r line; do
        idx=${line%:*}
        dest=${line#*:}
        set_audio_desc "$idx" "$dest"
    done

