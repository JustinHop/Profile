#!/bin/bash

#set -- "${1:-/dev/stdin}" "${@:2}"

dotransfer() {
    HOST="${1}"
    echo $HOST
    echo "$HOST : $(scp ~/b ${HOST}:)"
    echo "$HOST : $(scp /usr/share/terminfo/r/rxvt-unicode-256color ${HOST}:/usr/share/terminfo/r)"
}

export -f dotransfer

while read LINE ; do
    HOSTS="$HOSTS $LINE"
done

for HOST in $HOSTS $@ ; do
    echo $HOST
done | xargs -I{} -n1 -P16 bash -c 'dotransfer {}'
