#!/bin/bash

set -euo pipefail

set -x

DIR=/mnt/auto/h1/backup/borg

sudo borg init --encryption=repokey-blake2 $DIR || true

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
    --exclude '/home/*/Videos/*' \
    --exclude '/home/*/mopidy/data/*' \
    --exclude '/home/*/android/*' \
    --exclude '/home/*/tmp/*' \
    --exclude '/home/*/.tmp/*' \
    --exclude '/home/*/.git/*' \
    $DIR::'{hostname}-{now}' \
    /root \
    /etc \
    /home \
    /boot \
    /opt \
    /usr/local

sudo nice ionice -c 3 borg prune \
    --save-space \
    --verbose \
    --list \
    --prefix '{hostname}-' \
    --show-rc \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 6 \
    $DIR
