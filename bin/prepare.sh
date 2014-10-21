#!/bin/bash


for HOST in $(if test -t 0; then true ; else cat - ; fi) "$@" ; do 
    echo $HOST
done | xargs -n1 -P8 _prepare.sh
