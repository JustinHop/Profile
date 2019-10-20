#!/bin/bash
set -x

exec mpv \
    --keep-open=yes \
    --input-ipc-server=/tmp/mpvsocket \
    "$@"
