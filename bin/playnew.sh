#!/bin/zsh
set -euo pipefail
IFS=$'\n\t'

vidmanage lists

vidmanage show new | rl | xargs mpv
