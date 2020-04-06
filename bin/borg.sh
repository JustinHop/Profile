#!/bin/bash

#sudo borg init --encryption=repokey-blake2 /mnt/auto/4/backup

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
    /mnt/auto/4/backup::'{hostname}-{now}' \
    /etc \
    /home/justin

sudo nice ionice -c 3 borg prune \
    --save-space \
    --verbose \
    --list \
    --prefix '{hostname}-' \
    --show-rc \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 6 \
    /mnt/auto/4/backup
