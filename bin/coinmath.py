#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''coinmath
Usage: coinmath  [options]

Options:
    -c COUNT --count=COUNT      Number of coins
    -p PRICE --price=PRICE      Price per coin
    -t TOTAL --total=TOTAL      Total number of coins
    -s --scientific             Scientific notation

Python range notation for values
Omit one arg to figure it out
'''

from docopt import docopt
from math import log10,floor

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

def adjusted_scientific_notation(val,num_decimals=2,exponent_pad=2):
    exponent_template = "{:0>%d}" % exponent_pad
    mantissa_template = "{:.%df}" % num_decimals

    order_of_magnitude = floor(log10(abs(val)))
    nearest_third = 3*(order_of_magnitude//3+int(order_of_magnitude%3==2))
    adjusted_mantissa = val*10**(-nearest_third)
    adjusted_mantissa_string = mantissa_template.format(adjusted_mantissa)
    adjusted_exponent_string = "+-"[nearest_third<0] + exponent_template.format(abs(nearest_third))
    return adjusted_mantissa_string+"E"+adjusted_exponent_string

def readable_float(f):
    conf = get_conf()

    S = conf['--scientific']

    if S:
        return(adjusted_scientific_notation(f))
    else:
        if f > 1000000000000.0:
            return("{:15.3f}".format(f))
        elif f >= 1000000000.0:
            return("{:12.3f}".format(f))
        elif f >= 1000000.0:
            return("{:9.3f}".format(f))
        elif f >= 1000.0:
            return("{:6.3f}".format(f))
        elif f >= 1.0:
            return("{:3.3f}".format(f))
        elif f >= 0.001:
            return("{:3.6f}".format(f))
        elif f >= 0.000001:
            return("{:3.9f}".format(f))
        elif f >= 0.000000001:
            return("{:3.12f}".format(f))
        else:
            return("{:3.15f}".format(f))

def main():
    conf = get_conf()

    C = None
    P = None
    T = None

    try:
        C = conf['--count'].replace(',','')
    except:
        pass

    try:
        P = conf['--price'].replace(',','')
    except:
        pass

    try:
        T = conf['--total'].replace(',','')
    except:
        pass

    CC = arg_to_range(C)
    PP = arg_to_range(P)
    TT = arg_to_range(T)

    if C and P and not T:
        # Count and Price
        for c in CC:
            for p in PP:
                t = c * p
                pp = readable_float(p)
                tt = readable_float(t)
                cc = readable_float(c)
                print("{} coins at ${} per coin = total value ${}".format(cc, pp, tt))
    if P and T and not C:
        # Price and Total
        for p in PP:
            for t in TT:
                c = t/p
                pp = readable_float(p)
                tt = readable_float(t)
                cc = readable_float(c)
                print("${} total value at ${} per coin = {} coins".format(tt, pp, cc))
    if C and T and not P:
        # Count and Total
        for c in CC:
            for t in TT:
                p = t/c
                pp = readable_float(p)
                tt = readable_float(t)
                cc = readable_float(c)
                print("{} coins for total value ${} = ${} per coin ".format(cc, tt, pp))

if __name__ == "__main__":
    main()
