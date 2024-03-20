#!/bin/bash

ip=192.168.43.7
dir=mass
version=1.0

ip=192.168.43.40
dir=bulk
version=3.0

src="//$ip/$dir"
dst="$HOME/$dir"

if [[ $1 == mount ]]; then
    if mount | grep -q "$src"; then
        >&2 echo "$src has already been mounted."
        exit 0
    fi
    mkdir -p "$dst" && \
    sudo mount -t cifs "$src" "$dst" \
        -o vers=$version,_netdev,credentials=$HOME/.smbcred,uid=1000,gid=1000,iocharset=utf8,file_mode=0775,dir_mode=0775
elif [[ $1 == umount ]]; then
    if ! mount | grep -q "$src"; then
        >&2 echo "$src is not mounted."
        exit 1
    fi
    sudo umount "$dst" && \
    rmdir "$dst"
elif [[ $1 == synctime ]]; then
    sudo date -s $(ssh admin@$ip date '+%FT%T%z' 2>/dev/null)
else
    >&2 echo "usage: ${0##*/} [mount|umount|synctime]"
    exit 1
fi

