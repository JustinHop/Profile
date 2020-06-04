#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''video-summary
Usage: video-summary  [options] [FILE...]

Options:
    -h --human      Human readable sizes
    -D --debug      Debug output
    -t --title      Display output title
'''

from docopt import docopt
from pprint import pprint

import inspect
import tagpy
import mutagen
import os

import xmltodict
import subprocess

from collections import defaultdict, OrderedDict

conf = docopt(__doc__)


def debug(message):
    if conf['--debug']:
        print(inspect.stack()[1].function, ":", message)


def dotagpy(media):
    pprint(media)
    try:
        f = tagpy.FileRef(media)
        t = f.tag()
        pprint(t)
    except BaseException as e:
        print("Exception:", e)


def domutagen(media):
    pprint(media)
    try:
        f = mutagen.Metadata.load(media)
        pprint(f)
    except BaseException as e:
        print("Exception:", e)


def domediainfo(media):
    info = {}
    try:
        info['General_Filename'] = media
        info['General_Filesize'] = os.path.getsize(media)
    except BaseException as e:
        debug(e)
        return(info)

    debug(media)
    try:
        f = subprocess.run(
            ["mediainfo", "-F", "--output=XML", media],
            capture_output=True)
        t = xmltodict.parse(f.stdout)
        # pprint(t['MediaInfo']['media']['track'])
        for v in t['MediaInfo']['media']['track']:
            # print("v")
            debug(v)
            for k in v:
                if k == '@type' or k == '@typeorder':
                    # print("found type")
                    # pprint(v)
                    pass
                elif k == 'extra':
                    for kk in v[k]:
                        debug(v['@type'] + "_" + k + "_" + kk + "=" + v[k][kk])
                        info[str(v['@type']) +
                             "_" +
                             str(k) +
                             "_" +
                             str(kk)] = v[k][kk]

                else:
                    debug(v['@type'] + "_" + k + "=" + v[k])
                    info[str(v['@type']) + "_" + str(k)] = v[k]

    except BaseException as e:
        debug(e)
        # debug("Exception:" + str(e))

    try:
        info['Video_Geometry'] = info['Video_Width'] + "x" + info['Video_Height']
    except BaseException as e:
        print("Exception:", e)

    return(info)


def sizeof_fmt(input, suffix=''):
    if conf['--human']:
        try:
            num = int(input)
            for unit in ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z']:
                if abs(num) < 1024.0:
                    return "%3.1f%s%s" % (num, unit, suffix)
                num /= 1024.0
            return "%.1f%s%s" % (num, 'Y', suffix)
        except ValueError:
            pass
    return(str(input))


def display(info):
    i = []
    t = []
    ATTR = [['General_Filename'],
            ['General_Format'],
            ['General_Filesize'],
            ['General_OverallBitRate'],
            ['Video_CodecID'],
            ['Video_BitRate', 'Video_extra_FromStats_BitRate'],
            ['Video_Geometry'],
            ['Audio_CodecID'],
            ['Audio_BitRate', 'Audio_extra_FromStats_BitRate'],
            ]

    for attr in ATTR:
        found = 0
        for a in attr:
            if a in info and found == 0:
                debug(a)
                try:
                    ii = sizeof_fmt(info[a])
                    debug(ii)
                    i.append(ii)
                    found = 1
                except BaseException as e:
                    debug(e)
                    # debug("Exception:" + str(e))
            if a == attr[-1] and found == 0:
                i.append("0")


    if conf['--title'] and info['General_Filename'] == conf['FILE'][0]:
        for attr in ATTR:
            t.append(attr[0])
        print(" ".join(t))

    print(" ".join(i))


def main():
    debug(conf)
    for f in conf['FILE']:
        # domutagen(f)
        # dotagpy(f)
        display(domediainfo(f))


if __name__ == "__main__":
    main()
