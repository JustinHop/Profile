#!/bin/bash

cd

ssh ops1.sys.devqa1.websys.tmcs rm tm.bindForward \; nhs
scp ops1.sys.devqa1.websys.tmcs:tm.bindForward .
bindforward2hosts.sh | grep -v 127.0.0.1 | sudo tee /etc/hosts.tmcs
