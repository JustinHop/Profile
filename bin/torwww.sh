#!/bin/bash


if [ -d /tmp/clean-chromium ]; then
    rm -rf /tmp/clean-chromium
fi

cp -a ~/.config/clean-chromium-config/ /tmp/clean-chromium

chromium-browser --incognito --user-data-dir=/tmp/clean-chromium --proxy-server=socks5://localhost:9050 "$@"

rm -rf /tmp/clean-chromium
