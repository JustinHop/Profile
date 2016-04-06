#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


rpm -qa --queryformat '%{NAME}%{VERSION}%{RELEASE}\t%{VENDOR}\n' \
    | grep 'Red Hat, Inc.' | grep . || echo "NONE FOUND"
