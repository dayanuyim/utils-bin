#!/bin/bash

function ask_yesno {
    prompt="$1"
    def="$2"

    case "$def" in 
        [Nn]* ) defstr="y/N";;
        [Yy]* ) defstr="Y/n";;
        * )     defstr="y/n";;
    esac

    while true; do
        read -r -p $'\e[1;31m\e[47m'"==> $prompt ($defstr)?"$'\e[0m ' ans
        if [[ -z "$ans" ]]; then
            ans="$def"
        fi
        case "$ans" in 
            [Nn]* ) return 1;;
            [Yy]* ) return 0;;
            *) ;;
        esac
    done
}


# get the common prefix of two strings
function _common_prefix_2 {
    for (( i = 0; i < ${#1}; i++ )); do
        if [[ "${1:$i:1}" == "${2:$i:1}" ]]; then
            echo -n "${1:$i:1}"
        else
            return 0
        fi
    done
}

# get the common prifix of 0, 1, 2, or n strings
function common_prefix {
    p="$1"
    shift
    for s in "$@"; do
        p="$(_common_prefix_2 "$p" "$s")"
    done
    echo "$p"
}

