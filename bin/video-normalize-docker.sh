#!/bin/bash

IMAGE=jhoppensteadt/ffmpeg-normalize:latest

docker run --user 1000:44 -it --rm --device /dev/dri:/dev/dri -v "$(pwd)":"$(pwd)" -w "$(pwd)"  $IMAGE "$@"
