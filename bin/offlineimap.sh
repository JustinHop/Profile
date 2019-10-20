#!/bin/bash

ulimit -S -v 4000000
ulimit -H -v 4500000
while true ; do
    offlineimap
    sleep 5s
done

#offlineimap # 2>&1 | tee >(logger -p mail.debug)
