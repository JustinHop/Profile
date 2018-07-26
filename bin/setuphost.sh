#!/bin/bash

#set -- "${1:-/dev/stdin}" "${@:2}"

export SCP="-oConnectTimeout=5 -oBatchMode=yes"

dotransfer() {
    HOST="${1}"
    echo $HOST
    echo "$HOST : $(scp $SCP ~/b ${HOST}:)"
    echo "$HOST : $(scp $SCP ~/.screenrc ${HOST}:)"
    ssh ${HOST} mkdir .screenlogs
    #echo "$HOST : $(scp /usr/share/terminfo/r/rxvt-unicode-256color ${HOST}:/usr/share/terminfo/r)"
}

export -f dotransfer

if [ $1 == "-" ]; then
    while read LINE ; do
        HOSTS="$HOSTS $LINE"
    done
else
    HOSTS="$@"
fi

for HOST in $HOSTS ; do
    echo $HOST
done | xargs -I{} -n1 -P32 bash -c 'dotransfer {}'
