#!/usr/bin/env bash

if ! declare -p DRYRUN &>/dev/null; then
    DRYRUN=1
fi

source "$HOME/bin/libs.sh"

function exit_msg {
    echo "$1" >&2
    echo "usage: ${0##*/} SrcDir DstDir < LIST" >&2
    exit 1
}

# read global variables $Src, $Dst
function cp_mov
{
    if [[ -z $Src || -z $Dst ]]; then
        echo "error: no src or dst folders" >&2
        exit 2
    fi

    [[ -n $DRYRUN ]] && flag='-n' || flag=

    mov="$1"
    shift

    rsync -avhP $flag \
        --exclude='.*' \
        --exclude='.DS_Store' \
        --exclude='~uTorrent*.dat' \
        --exclude='RARBG*' \
        --exclude='YIYF*.txt' \
        --exclude='*YTS*.jpg' \
        "$Src/$mov" "$Dst/" \
        && \
        echo "${c_blueB}$(mov-rename $flag "$Dst/$mov" "$@")${c_end}"
}


function bar
{
    w=$(($(tput cols) - 2))
    echo -n "$(str_repeat '=' $w)>"
}

#___Src="${1%/}"
#___Dst="${2%/}"
#___
#___if [[ ! -d $Src ]]; then
#___    exit_msg "error: SRC folder '$Src' does not exist."
#___fi
#___
#___if [[ -z $DRYRUN && ! -d $Dst ]]; then
#___    exit_msg "error: DST folder '$Dst' does not exist."
#___fi

bar=$(bar)
cnt=1
while IFS= read -r line; do
    case "$line" in
        "" | "#"*)
            ;;
        "< "*) Src="${line:2}"
            ;;
        "> "*) Dst="${line:2}"
            ;;
        *)
            mov="$line"
            IFS= read -r title
            IFS= read -r sn

            header="$(printf "#%03d   %-100s %-30s %3s" "$cnt" "$mov" "$title" "$sn")"
            echo "$bar"
            echo "${c_greenB}$header${c_end}"

            cp_mov "$mov" "$title" "$sn"
            ((++cnt))
            ;;
    esac
done

if [[ -n $DRYRUN ]]; then
    echo "-=[DRYRUN]=-"
fi
