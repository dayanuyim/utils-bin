#!/usr/bin/env bash

# launch VLC with customed options

RC="$HOME/Library/Preferences/org.videolan.vlc/vlcrc"
VLC="/Applications/VLC.app/Contents/MacOS/VLC"

KAI_FONT=TW-Kai-98_1
#SANS_FONT=ArialUnicodeMS
SANS_FONT=SourceHanSansTC-Normal

function set_vlcrc
{
    key="$1"
    val="$2"

    sed -i bak "s/$key=.*/$key=$val/" "$RC"
}

case "$1" in
    en) set_vlcrc freetype-font "$SANS_FONT"
        set_vlcrc freetype-rel-fontsize 16
        ;;
    zh) set_vlcrc freetype-font "$KAI_FONT"
        set_vlcrc freetype-rel-fontsize 12
        ;;
    ez) set_vlcrc freetype-font "$KAI_FONT"
        set_vlcrc freetype-rel-fontsize 16
        ;;
    *)  echo "Setting VLC with Pre-defined Options"
        echo "usage: ${0##*/} [option]" >&2
        echo "   avaliable options: en, zh, ez"
        exit 1
        ;;
esac

#$VLC
