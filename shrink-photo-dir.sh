#!/usr/bin/env bash

target="photo"
orig="${target}.orig"

cmd="shrink-image"

mv "$target" "$orig" && \
    mirror "$cmd" "$orig" "$target" && \
    trash "$orig"
