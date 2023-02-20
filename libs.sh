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


