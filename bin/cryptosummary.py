#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''cryptosummary

Usage: cryptosummary [options]

Options:
    -t TTL, --ttl=TTL     Cache cryptwatch results this many seconds [default: 300]

'''

s = {
        'btcusd': {
            'gdax': 0.0,
            'bitstamp': 0.0,
            'bittrex': 0.0,
            'cex.io': 0.0,
        },
        'ethusd': {
            'gdax': 0.0,
            'bitstamp': 0.0,
            'bittrex': 0.0,
            'cex.io': 0.0,
        },
        'ethbtc': {
            'gdax': 0.0,
            'bitstamp': 0.0,
            'bittrex': 0.0,
            'cex.io': 0.0,
        },
}


m_url = 'https://api.cryptowat.ch/markets/{}/{}/summary'

import requests_cache, requests
from docopt import docopt

import json
import texttable
import numpy as np

def debug(m):
    print("DEBUG: {}".format(m))


def get_conf():
    conf = docopt(__doc__)
    return(conf)


def get_last(market, exchange):
    try:
        v = get_summary(market, exchange)
        debug("get_last({}, {}): {}".format(market, exchange, v['price']['last']))
        return(v['price']['last'])
    except BaseException as e:
        debug("get_last({}, {}): error: {}".format(market, exchange, e))
        return(0)



def get_summary(market, exchange):
    conf = get_conf()
    requests_cache.install_cache('/tmp/cryptowatch', expire_after=int(conf['--ttl']))

    try:
        r = requests.get(m_url.format(exchange, market))
        j = json.loads(r.text)
        debug(j['allowance'])
        return(j['result'])
    except BaseException as e:
        debug("get_summary({}, {}): error: {}".format(market, exchange, e))

def format_si(number, significant_digits=3):
    """Format number using SI prefixes

    The prefix is chosen such that the number before the prefix is 1<x<1000."""
    if number == 0:
        return '0 '
    prefixes = list('afpnμm') + [''] + list('kMGTPE')
    multipliers = 10.**np.arange(-18, 19, 3)
    inv_multipliers = 10.**(-np.arange(-18, 19, 3))
    abs_number = abs(number)
    index = np.searchsorted(multipliers, abs_number) - 1
    prefix = prefixes[index]
    number *= inv_multipliers[index]
    abs_number = inv_multipliers[index] * abs_number
    if (abs_number > 1000 or abs_number < 1) and (
            index == -1 or index == len(multipliers)-1):
        format_ = '{:.3e} '
        number *= multipliers[index]
    else:
        if abs_number < 10:
            digits_before_comma = 1
        elif abs_number < 100:
            digits_before_comma = 2
        else:
            digits_before_comma = 3
        decimals = max(0, significant_digits - digits_before_comma)
        format_ = '{:.' + str(decimals) + 'f} {}'
    return format_.format(number, prefix)


def do_display():
    x = texttable.Texttable()
    x.set_cols_width([8, 9,
                      9, 9, 10,
                      9, 9, 10,
                      9, 9, 10,
                      9, 9, 10,
                      8,
                      ])
    x.set_cols_dtype(['t', 'a',
                      'a', 'a', 'a',
                      'a', 'a', 'a',
                      'a', 'a', 'a',
                      'a', 'e', 'e',
                      't',
                      ])
    x.add_row(['Market', 'BTCUSD',
               'ETHUSD', 'ETHBTC', 'ETHBTC2USD',
               'LTCUSD', 'LTCBTC', 'LTCBTC2USD',
               'BCHUSD', 'BCHBTC', 'BCHBTC2USD',
               'XRPUSD', 'XRPBTC', 'XRPBTC2USD',
               'Market',
               ])
    x.add_row(['GDAX',
               get_last('btcusd', 'gdax'),
               format_si(get_last('ethusd', 'gdax')),
               format_si(get_last('ethbtc', 'gdax')),
               format_si(float(get_last('ethbtc', 'gdax')) * float(get_last('btcusd', 'gdax'))),
               format_si(get_last('ltcusd', 'gdax')),
               format_si(get_last('ltcbtc', 'gdax')),
               format_si(float(get_last('ltcbtc', 'gdax')) * float(get_last('btcusd', 'gdax'))),
               'x','x','x',
               'x','x','x',
               'GDAX',
               ])
    x.add_row(['Bitstamp',
               get_last('btcusd', 'bitstamp'),
               get_last('ethusd', 'bitstamp'),
               format_si(get_last('ethbtc', 'bitstamp')),
               float(get_last('ethbtc', 'bitstamp')) * float(get_last('btcusd', 'bitstamp')),
               format_si(get_last('ltcusd', 'bitstamp')),
               format_si(get_last('ltcbtc', 'bitstamp')),
               format_si(float(get_last('ltcbtc', 'bitstamp')) * float(get_last('btcusd', 'bitstamp'))),
               get_last('bchusd', 'bitstamp'),
               format_si(get_last('bchbtc', 'bitstamp')),
               float(get_last('bchbtc', 'bitstamp')) * float(get_last('btcusd', 'bitstamp')),
               format_si(get_last('xrpusd', 'bitstamp')),
               format_si(get_last('xrpbtc', 'bitstamp')),
               format_si(float(get_last('xrpbtc', 'bitstamp')) * float(get_last('btcusd', 'bitstamp'))),
               'Bitstamp',
               ])
    x.add_row(['Bittrex',
               get_last('btcusdt', 'bittrex'),
               get_last('ethusdt', 'bittrex'),
               format_si(get_last('ethbtc', 'bittrex')),
               float(get_last('ethbtc', 'bittrex')) * float(get_last('btcusdt', 'bittrex')),
               'x','x','x',
               get_last('bccusdt', 'bittrex'),
               format_si(get_last('bccbtc', 'bittrex')),
               float(get_last('bccbtc', 'bittrex')) * float(get_last('btcusdt', 'bittrex')),
               format_si(get_last('xrpusdt', 'bittrex')), 'x', 'x',
               'Bittrex',
               ])
    x.add_row(['CEX.IO',
               get_last('btcusd', 'cexio'),
               get_last('ethusd', 'cexio'),
               format_si(get_last('ethbtc', 'cexio')),
               float(get_last('ethbtc', 'cexio')) * float(get_last('btcusd', 'cexio')),
               'x','x','x',
               get_last('bchusd', 'cexio'), 'x', 'x',
               'x','x','x',
               'CEX.IO',
               ])

    print(x.draw())

def main():
    conf = get_conf()
    debug(conf)

    do_display()


if __name__ == "__main__":
    main()
