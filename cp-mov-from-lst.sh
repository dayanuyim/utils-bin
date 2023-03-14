#!/usr/bin/env bash

# if ! declare -p DRYRUN &>/dev/null; then
#     DRYRUN=1
# fi

source "$HOME/bin/libs.sh"

function errmsg_exit {
    echo "$1" >&2
    echo "usage: ${0##*/} lst" >&2
    exit 1
}

# read global variables $Src, $Dst
function cp_mov
{
    if [[ -z $Src || -z $Dst ]]; then
        echo "error: no src or dst folders" >&2
        exit 2
    fi

    [[ "$1" == "--dry-run" ]] && flag="$1" && shift || flag=

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

function run
{
    clear && tmux clear-history

    [[ "$1" == "--dry-run" ]] && flag="$1" && shift || flag=

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

                cp_mov $flag "$mov" "$title" "$sn"
                ((++cnt))
                ;;
        esac
    done
}

lst="$1"
if [[ ! -f $lst ]]; then
    errmsg_exit "error: no list file '$lst'"
    exit 1
fi

run --dry-run < "$lst"
if ask_yesno "Do the copy"; then
    run < "$lst"
fi
