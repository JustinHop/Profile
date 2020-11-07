#!/bin/zsh

cd /mnt/auto/1/share/Video

for i in $(find -L -type d | grep -v 'eaDir' | grep -v 'new' | rl) ; do
    if [ -d $i ]; then
        pushd $i
        pwd;pwd;pwd;pwd;
        #namenorm *
        video-normalize.sh -f $(find -L -maxdepth 1 -type f -size +100M)
        popd
    fi
done

#echo > /tmp/emptyfile
#find /tmp -maxdepth 1 -name '*.wav' -type f -exec rm -v {} \;
#find -L /mnt/auto/1/share/Video -type f -name '-volnorm.mp4' -exec cp -v /tmp/emptyfile {} \;
