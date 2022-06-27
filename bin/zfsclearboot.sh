#!/bin/bash




zfs list -r -t snapshot -o name,used,referenced,creation bpool/BOOT | head -n 6 | cut -c 35-40 | xargs -n1 sudo zsysctl state remove --system
