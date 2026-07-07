#!/bin/bash


if [ $# -eq 0 ]; then
    # use the PWD basename as the default session name
    /usr/bin/tmux -u new -s "$(basename "$PWD")"
else
    /usr/bin/tmux -u "$@"
fi
