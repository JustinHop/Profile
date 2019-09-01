#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''splitvid

Usage:
  splitvid.py [options]

Options:
  -d --debug       Debug
  -h --help        Help message
  -n --dry-run     Dry Run

'''
from __future__ import unicode_literals

from docopt import docopt
#from pathlib import Path

import sys
import re

ff = 'ffmpeg -i VIDEO -acodec copy -vcodec copy -ss START -to END OUT'


def get_conf():
    conf = docopt(__doc__)
    return(conf)


def main():
    conf = get_conf()
    if conf['--debug']:
        print(conf)
    times = ['00:00:00']
    video = ""

    for line in sys.stdin:
        line = line.rstrip('\n')
        if re.match(
            r'^\S+\.(mp4|wmv|mov|f4v|mkv|avi|mpg|mpeg)\s+\d\d:\d\d:\d\d', line,
                re.IGNORECASE):
            if conf['--debug']:
                print("Line Matched", line)
            [f, t] = line.split(u' ')
            times.append(t)
            video = f

    for idx, item in enumerate(times):
        cmd = re.sub(u'VIDEO', "'" + video + "'", ff)
        cmd = re.sub(u'START', times[idx], cmd)
        if idx + 1 >= len(times):
            cmd = re.sub(u'-to END', "", cmd)
        else:
            cmd = re.sub(u'END', times[idx + 1], cmd)

        scene = re.sub(ur'^(.*)(\.\S+$)', ur"'\1.sceneXXX\2'", video)
        scene = re.sub(ur'XXX', str(idx + 1), scene)

        cmd = re.sub(ur'OUT', scene, cmd)

        if conf['--debug']:
            print(idx, item, len(times), cmd)
        print(cmd)


if __name__ == "__main__":
    main()


#  vim: set ft=python ts=4 sw=4 tw=79 et :
