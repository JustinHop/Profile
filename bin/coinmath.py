#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''coinmath
Usage: coinmath  [options]

Options:
    -c COUNT --count=COUNT      Number of coins
    -p PRICE --price=PRICE      Price per coin
    -t TOTAL --total=TOTAL      Total number of coins

Python range notation for values
Omit one arg to figure it out
'''

from docopt import docopt

import numpy as np

def get_conf():
    conf = docopt(__doc__)
    return(conf)

def list_str_to_float(arg):
    out = []
    for i in arg:
        out.append(float(i))
    return(out)

def arg_to_range(arg):
    try:
        a = list_str_to_float(arg.split(':'))
        if len(a) == 1:
            return(a)
        if len(a) == 2:
            return(np.arange(a[0], a[1]))
        if len(a) == 3:
            return(np.arange(a[0], a[1], a[2]))
    except AttributeError:
        return(None)


def main():
    conf = get_conf()

    C = conf['--count']
    P = conf['--price']
    T = conf['--total']

    CC = arg_to_range(C)
    PP = arg_to_range(P)
    TT = arg_to_range(T)

    if C and P and not T:
        # Count and Price
        for c in CC:
            for p in PP:
                print("{:5.10f} coins at ${:9.6f} per coin = total value ${:<20.6f}".format(c, p, c * p))
    if P and T and not C:
        # Price and Total
        for p in PP:
            for t in TT:
                print("${:<10.6f} total value at ${:8.6f} per coin = {:12f} coins".format(t, p, t/p))
    if C and T and not P:
        # Count and Total
        for c in CC:
            for t in TT:
                print("{:10f} coins for total value ${:<10.6f} = ${:9.6f} per coin ".format(c, t, t/c))



if __name__ == "__main__":
    main()
