#!/bin/bash

docker ps -a |grep Exited | awk '{ print $1 }' | xargs docker rm

docker rmi $(docker images -q -f dangling=true)
