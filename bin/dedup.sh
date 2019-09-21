#!/bin/bash

for FILE in 2019-03-19/* ; do
    B=$(basename "$FILE")
    if [ -f new/"$B" ]; then
        #ls -l $PWD/$FILE
        #ls -l $PWD/new/$B
        rm -v $PWD/new/"$B"
    fi
done
