#!/usr/bin/env python3
# -*- coding: utf-8 -*-

stamp = 'https://www.bitstamp.net/api/ticker/'
stamp2 = 'https://www.bitstamp.net/api/v2/ticker/'

green = '859900'
red = 'dc322f'

import requests
import subprocess
import json
import time
import os

V = {
    'btcusd': 0.0,
    'bchusd': 0.0,
    'ethusd': 0.0,
    'ltcusd': 0.0,
    'xrpusd': 0.0,
}


def debug(d):
    # print("DEBUG:", d)
    pass


def tooltip(crypto, r):
    t = """bitstamp {}\n{}""".format(
        crypto, json.dumps(
            r, sort_keys=True, indent=4))
    # cmd = """set -x; echo \"{}_tooltip:set_markup(\'{}\')\" | awesome-client""".format(crypto, t.replace('"', ''))
    cmd = """echo "{}_tooltip:set_markup('{}')" | awesome-client """.format(
        crypto, t.replace('"', ''))
    cmd = ''.join(cmd.splitlines())
    # debug("tooltip({}):cmd:{}".format(crypto, cmd))
    print(subprocess.check_output(cmd, shell=True))


def getcrypt(crypto):
    # debug("getcrypt({})".format(crypto))
    try:
        r = requests.get("{}{}".format(stamp2,  crypto))
        # debug("getcrypt({}): response: {}".format(crypto, r.status_code))
        b = json.loads(r.text)
        return(b)
    except BaseException as e:
        # debug("getcrypt({}): error: {}".format(crypto, e))
        b = []
        b['last'] = 0.0


def looper():
    for c in sorted(V.keys()):
        try:
            r = getcrypt(c)
            # debug("looper():{}:r:{}".format(c, r))
            last = float(r['last'])
            if last >= V[c]:
                color = green
            else:
                color = red
            print("{} {} {}".format(c, color, last))
            cmd = """echo "{}:set_markup('<span color=\\\"#{}\\\">{:.2f}</span>')" | awesome-client""".format(
                c, color, last)
            debug("looper():{}:cmd:{}".format(c, cmd))
            subprocess.run(cmd, shell=True)
            tooltip(c, r)
            V[c] = last
        except BaseException as e:
            # debug("looper():{}:Exception:{}".format(c, e))
            pass


def main():
    while True:
        looper()
        time.sleep(120)


if __name__ == "__main__":
    main()
