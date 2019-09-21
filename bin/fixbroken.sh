#!/bin/bash
set -x

cd /mnt/auto/1/share/Video

find -L -name '*volnorm*' | sed 's/-volnorm//' | xargs ./encode.sh
