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
    'linkusd': 0.0,
}

AWESOME_CLIENT = "/usr/local/bin/awesome-client"

def debug(d):
    # print("DEBUG:", d)
    pass


def tooltip(crypto, r):
    t = """bitstamp {}\n{}""".format(
        crypto, json.dumps(
            r, sort_keys=True, indent=4))
    # cmd = """set -x; echo \"{}_tooltip:set_markup(\'{}\')\" | awesome-client""".format(crypto, t.replace('"', ''))
    cmd = """echo "{}_tooltip:set_markup('{}')" | {} """.format(
        crypto, t.replace('"', ''), AWESOME_CLIENT)
    cmd = ''.join(cmd.splitlines())
    # debug("tooltip({}):cmd:{}".format(crypto, cmd))
    debug(subprocess.check_output(cmd, shell=True))


def getcrypt(crypto):
    # debug("getcrypt({})".format(crypto))
    try:
        r = requests.get("{}{}".format(stamp2,  crypto))
        debug("getcrypt({}): response: {}".format(crypto, r.status_code))
        b = json.loads(r.text)
        return(b)
    except BaseException as e:
        debug("getcrypt({}): error: {}".format(crypto, e))
        b = []
        b['last'] = 0.0

def looplooper(data):
    try:
        cmd = ''' echo "
        local awful = require('awful')
        local gears = require('gears')
        gears.protected_call(function()
            awful.screen.connect_for_each_screen(function(s)
                if s.index == 3 then
                    s.btcusd:set_markup('<span color=\\\"#{}\\\"> {:.2f} </span>')
                    s.ethusd:set_markup('<span color=\\\"#{}\\\"> {:.2f} </span>')
                    s.bchusd:set_markup('<span color=\\\"#{}\\\"> {:.2f} </span>')
                elseif s.index == 2 then
                    s.ltcusd:set_markup('<span color=\\\"#{}\\\"> {:.2f} </span>')
                    s.linkusd:set_markup('<span color=\\\"#{}\\\"> {:.2f} </span>')
                end
            end)
        end) " | {}
        '''.format(
            data['btcusd']['color'], data['btcusd']['last'],
            data['ethusd']['color'], data['ethusd']['last'],
            data['bchusd']['color'], data['bchusd']['last'],
            data['ltcusd']['color'], data['ltcusd']['last'],
            data['linkusd']['color'], data['linkusd']['last'],
            AWESOME_CLIENT
        )
        debug("looplooper(command): " + cmd)
        subprocess.run(cmd, shell=True)
    except KeyError as x:
        print(x)


def looper():
    data = {}
    for c in sorted(V.keys()):
        try:
            r = getcrypt(c)
            # debug("looper():{}:r:{}".format(c, r))
            last = float(r['last'])
            if last >= V[c]:
                color = green
            else:
                color = red
            debug("{} {} {}".format(c, color, last))
            data[c] = { "color": color, "last": last, "name": c }
            #debug("looper():{}:cmd:{}".format(c, cmd))
            #subprocess.run(cmd, shell=True)
            #tooltip(c, r)
            V[c] = last
        except BaseException as e:
            debug("looper():{}:Exception:{}".format(c, e))
            pass
    try:
        debug(data)
        looplooper(data)
    except BaseException as x:
        print(x)


def main():
    while True:
        looper()
        time.sleep(180)


if __name__ == "__main__":
    main()
