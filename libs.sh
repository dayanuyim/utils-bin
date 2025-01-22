#!/bin/bash

c_end=$'\e[0m'

b_black=$'\e[40m'
b_red=$'\e[41m'
b_green=$'\e[42m'
b_yellow=$'\e[43m'
b_blue=$'\e[44m'
b_magenta=$'\e[45m'
b_cyan=$'\e[46m'
b_lightgray=$'\e[47m'
b_gray=$'\e[100m'
b_lightred=$'\e[101m'
b_lightgreen=$'\e[102m'
b_lightyellow=$'\e[103m'
b_lightblue=$'\e[104m'
b_lightmagenta=$'\e[105m'
b_lightcyan=$'\e[106m'
b_white=$'\e[107m'

c_black=$'\e[0;30m'
c_red=$'\e[0;31m'
c_green=$'\e[0;32m'
c_yellow=$'\e[0;33m'
c_blue=$'\e[0;34m'
c_magenta=$'\e[0;35m'
c_cyan=$'\e[0;36m'
c_lightgray=$'\e[0;37m'
c_gray=$'\e[0;90m'
c_lightred=$'\e[0;91m'
c_lightgreen=$'\e[0;92m'
c_lightyellow=$'\e[0;93m'
c_lightblue=$'\e[0;94m'
c_lightmagenta=$'\e[0;95m'
c_lightcyan=$'\e[0;96m'
c_white=$'\e[0;97m'

c_blackB=$'\e[1;30m'
c_redB=$'\e[1;31m'
c_greenB=$'\e[1;32m'
c_yellowB=$'\e[1;33m'
c_blueB=$'\e[1;34m'
c_magentaB=$'\e[1;35m'
c_cyanB=$'\e[1;36m'
c_lightgrayB=$'\e[1;37m'
c_grayB=$'\e[1;90m'
c_lightredB=$'\e[1;91m'
c_lightgreenB=$'\e[1;92m'
c_lightyellowB=$'\e[1;93m'
c_lightblueB=$'\e[1;94m'
c_lightmagentaB=$'\e[1;95m'
c_lightcyanB=$'\e[1;96m'
c_whiteB=$'\e[1;97m'

############################################################

function ask_yesno {
    prompt="$1"
    def="$2"

    case "$def" in
        [Nn]* ) defstr="y/N";;
        [Yy]* ) defstr="Y/n";;
        * )     defstr="y/n";;
    esac

    while true; do
        read -r -p "${c_blueB}${b_lightgray}==> $prompt ($defstr)?${c_end} " ans
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

function str_repeat {
    printf "$1%.0s" $(seq $2)
}

# Remove /./ and dir/.. sequences from a pathname and write result to stdout.
function normalize_path {
    # Remove all /./ sequences.
    local   path=${1//\/.\//\/}

    # Remove dir/.. sequences.
    while [[ $path =~ ([^/][^/]*/\.\./) ]]
    do
        path=${path/${BASH_REMATCH[0]}/}
    done
    echo $path
}

function _clear_chars(){
    local n="${1:-1}"
    local chars=""
    for ((i = 0; i < $n; i++)); do
        chars="${chars}\e[D\e[P"
    done
    echo -ne "$chars"
}

# puting clear and display together will eliminate possible visual delay
function _update_chars(){
    if [[ "$1" != "$2" ]]; then
        _clear_chars ${#1}
        echo -n "$2"
    fi
}

function _add_bounded(){
    local num="$1"
    local addend="$2"
    local min=$3
    local max=$4
    num=$((num + addend))
    if [[ $num -lt "$min" ]]; then
        num="$min"
    fi
    if [[ $num -gt "$max" ]]; then
        num=$max
    fi
    echo -n "$num"
}


# read a number in the <input type="number"> style,
# which supports arrow keys to step the number
function readNumber(){
    local num=$1
    local min=$2
    local max=$3
    local step=${4:-1}

    echo >&2 -n "$num"

    while true;
    do
        # Read a single character (-s suppresses output, -n1 reads one character)
        # if it's an escape sequence, read the next two characters for the escape sequence.
        read -rsN1 ch
        if [[ $ch == $'\e' ]]; then
            read -rsN2 -t 0.1 ch
        fi

        #local orig=
        case "$ch" in
            "[A" | "[C") # up | right
                local orig="$num"
                num=$(_add_bounded "$num" "$step" "$min" "$max")
                _update_chars >&2 "$orig" "$num"
                ;;
            "[B" | "[D") # down | left
                local orig="$num"
                num=$(_add_bounded "$num" "-$step" "$min" "$max")
                _update_chars >&2 "$orig" "$num"
                ;;
            [0-9]) # digit
                echo >&2 -n "$ch"
                num="${num}${ch}"
                ;;
            $'\b' | $'\177') # delete
				if [[ -n "$num" ]]; then
					num="${num::-1}"
                    _clear_chars 1 >&2
				fi
                ;;
            $'\n') # enter
                echo >&2 ''
                if [[ $num -lt 0 || $num -gt "$max" ]]; then
                    echo >&2 "page '$num' not in the valid range [1, $max]"
                    num=
                fi
                break
                ;;
            q|Q)
                return 1
                ;;
            *)
                ;;
        esac
    done

    echo -n $num
    return 0
}
