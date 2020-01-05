#!/bin/zsh

set -euo pipefail
IFS=$'\t\n'

set -x


https://invidio.us/watch?v=kZfKkc21-tI

xclip -o | sed -e 's/invidio.us/youtube.com/' -e 's/hooktube.com/youtube.com/' | xargs -r catt add &
