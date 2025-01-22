#!/bin/sh
##################################################################################
# This is a wrapper to help run a script remotely via ssh.
# To use the wrapper, create a link to the warpper with the same filename in the same dir,
# but suffixing the hostname you want to run.
#
# For example:
#   1. to run a script       /path/to/a/script.sh,
#   2. jsut create the link  /path/to/a/script@HOST.sh    to the wrapper
##################################################################################

dir="$(dirname "$(realpath --no-symlinks "$0")")"
name="${0##*/}"
ext="${name##*.}"
name="${name%.*}"

host="${name##*@}"
script="${dir}/${name%@*}.${ext}"

if [ -z "$host" ]; then
    echo >&2 "no HOST specified in the filename '${0##*/}'"
    exit 1
fi

echo >&2 "[+] ssh \"$host\" bash -s < \"$script\" \"$@\""
ssh "$host" bash -s < "$script" "$@"
