#!/usr/bin/env bash

####################################################################
# Remote Page Turner for Digital Paper via WiFi
#     based on [dpt-rp1-py](https://github.com/janten/dpt-rp1-py)
####################################################################

source "$HOME/bin/libs.sh"

function getDeviceAddr(){
    dptrp1 get-configuration /dev/stdout | grep 'Found digital paper at' | awk '{print $NF}'
}


function getTotalPage(){
    dptrp1 --addr "$ADDR" document-info "$1" | grep total_page | awk '{print $NF}'
}

function gotoPage(){
    echo >&2 "Going to page $2."
    dptrp1 --addr "$ADDR" display-document "$1" "$2"
}

# check the format
doc="$1"
if [[ -z "$doc" ]]; then
    echo >&2 "usage: ${0##*/} DOCUMENT-PATH [page]"
    exit 9
fi

# check if the device exists
ADDR="$(getDeviceAddr)"
if [[ -z "$ADDR" ]]; then
    echo >&2 "error: cannot find device."
    exit 1
fi

# check if the doc exists
total=$(getTotalPage "$doc")
if [[ -z "$total" ]]; then
    echo >&2 "error: cannot get the toal page of '$doc'."
    exit 2
fi

# get inital page
page="${2:-1}"

# got to the initial page
gotoPage "$doc" "$page"

echo "---------------------------------------------------------------"
echo "ADDR: $ADDR"
echo "CURRENT PAGE: $page; TOTAL PAGE: $total"
echo "Press arrow keys or input the page number. (Press 'q' to quit.)"
echo "---------------------------------------------------------------"

while true; do
    # prompt
	echo -n "${c_blue}${doc##*/} ${c_white}${b_gray} $page ${c_end}> "

    # get number
    if ! num="$(readNumber "$total" $page)"; then
        echo >&2 "Quitting..."
        exit 0
    fi

    # go to the page num
    if [[ -n "$num" ]]; then
        page=$num
        gotoPage "$doc" "$page"
    fi
done
