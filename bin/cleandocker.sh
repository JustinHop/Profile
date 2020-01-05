#!/bin/bash

set -euo pipefail
set -x

docker ps -a |grep Exited | awk '{ print $1 }' | xargs -r docker rm

docker rmi $(docker images -q -f dangling=true)
