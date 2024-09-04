#!/usr/bin/env bash

# if ! declare -p DRYRUN &>/dev/null; then
#     DRYRUN=1
# fi

source "$HOME/bin/libs.sh"

inventory=()

function errmsg_exit {
    echo "$1" >&2
    echo "usage: ${0##*/} lst" >&2
    exit 1
}

# read global variables $Src, $Dst
function cp_mov
{
    if [[ -z $Src ]]; then
        echo "error: no source folder specified" >&2
        exit 2
    fi

    if [[ -z $Dst ]]; then
        echo "error: no destination folder specified" >&2
        exit 2
    fi

    local flag=
    if [[ "$1" == "--dry-run" ]]; then
        flag=$1 && shift
    fi

    local mov="$1" && shift

    if rsync -avhP $flag \
        --exclude='.*' \
        --exclude='.DS_Store' \
        --exclude='~uTorrent*.dat' \
        --exclude='RARBG*' \
        --exclude='YIFY*.txt' \
        --exclude='*YTS*.jpg' \
        "$Src/$mov" "$Dst/" ;
    then
        local res="$(mov-rename $flag "$Dst/$mov" "$@")"
        echo "${c_blueB}$res${c_end}"
        inventory+=("$(awk -F " -> " '{print $NF}' <<< "$res")")
    fi
}


function bar
{
    w=$(($(tput cols) - 2))
    echo -n "$(str_repeat '=' $w)>"
}

function flushInv {
    MOV_DIR=/Volumes/bulk/Movie
    MOV_LST="$HOME/Dropbox/Doc_文件/movies.lst"

    echo "$(bar)"
    local lst="$([[ $1 == "--dry-run" ]] && echo "/dev/null" || echo "$MOV_LST")"
    printf '%s\n' "${inventory[@]}" | sed 's#^'$MOV_DIR/'##' | tee -a "$lst" | nl -n rz -w2 -s'  '
    inventory=() #clean
}

function run
{
    clear && tmux clear-history

    local flag=
    if [[ "$1" == "--dry-run" ]]; then
        flag=$1 && shift
    fi

    local bar=$(bar)
    local cnt=1
    while IFS= read -r line; do
        case "$line" in
            "" | "#"*)
                ;;
            "< "*) Src="${line:2}"
                ;;
            "> "*) Dst="${line:2}"
                ;;
            *)
                local mov="$line"
                IFS= read -r title
                IFS= read -r sn

                header="$(printf "#%03d   %-100s %-3s %-30s" "$cnt" "$mov" "$sn" "$title" )"
                echo "$bar"
                echo "${c_greenB}$header${c_end}"

                cp_mov $flag "$mov" "$title" "$sn"
                ((++cnt))
                ;;
        esac
    done

    local count=${#inventory}
    flushInv $flag
    return $count
}

lst="$1"
if [[ ! -f $lst ]]; then
    errmsg_exit "error: no list file '$lst'"
    exit 1
fi

run --dry-run < "$lst"

count=$?
if [[ $count == 0 ]]; then
    echo >&2 "no entry in the list."
    exit 0
fi

if ask_yesno "Do the copy"; then
    run < "$lst"
fi
