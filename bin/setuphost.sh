#!/bin/bash

while read LINE ; do
    scp ~/b ${LINE}:
    scp /usr/share/terminfo/r/rxvt-unicode-256color ${LINE}:/usr/share/terminfo/r
done
