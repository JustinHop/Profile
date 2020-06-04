#!/bin/zsh

set -euo pipefail
IFS=$'\t\n'

# set -x


#https://invidio.us/watch?v=kZfKkc21-tI

#invidio.us
xclip -o | tee /dev/stderr | sed -e 's/invidio.us/youtube.com/' -e 's/hooktube.com/youtube.com/' | tee /dev/stderr | xargs -r catt cast
echo
