#!/bin/bash

DIR=/mnt/auto/backup

echo sudo borg init --encryption=repokey-blake2 $DIR

sudo nice ionice -c 3 borg create \
    --verbose \
    --progress \
    --show-version \
    --show-rc \
    --stats \
    --list \
    --filter AME \
    --exclude-caches \
    --compression auto,lzma \
    --exclude '/home/*/.cache/*' \
    --exclude '/home/*/Cache*/*' \
    --exclude '/home/*/.thumbnails/*' \
    --exclude '/home/*/Music/*' \
    --exclude '/home/*/mopidy/data/*' \
    --exclude '/home/*/android/*' \
    --exclude '/home/*/tmp/*' \
    --exclude '/home/*/.tmp/*' \
    --exclude '/home/*/*.iso' \
    --exclude '/home/*/*.img' \
    --exclude '/home/*/*.rpm' \
    --exclude '/home/*/.git/*' \
    --exclude '/home/*/.svn/*' \
    --exclude '/home/wallet/.bitmonero/lmdb/data.mdb' \
    --exclude '/home/wallet/.*/*db' \
    ${DIR}::'{hostname}-{now}' \
    /etc \
    /home/justin \
    /home/yield \
    /home/trader \
    /home/wallet \
    /home/additive \
    /home/ethereum

sudo nice ionice -c 3 borg prune \
    --save-space \
    --verbose \
    --list \
    --prefix '{hostname}-' \
    --show-rc \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 12 \
    ${DIR}
