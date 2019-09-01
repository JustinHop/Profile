#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''coinmath
Usage: coinmath  [options] START END [MULTIPLIER]

Arguements:
     MULTIPLIER                      Multiplier [default: 1]

'''
from docopt import docopt

import numpy as np

def get_conf():
    conf = docopt(__doc__)
    return(conf)

def main():
    conf=get_conf()
    # print(conf)

    s = np.float64(conf['START'])
    e = np.float64(conf['END'])
    

    m = 1
    mline = ""

    if conf['MULTIPLIER']:
        m = np.float64(conf['MULTIPLIER'])

    p = np.float64((e-s)/s)
    c = np.float64(e - s)

    if m != 1:
        mline = "; {} * {} = {};  {} * {} = {}".format(s,m,s*m,e,m,e*m)
        mline = mline + "; {} * {} = {}".format(c, m, m*c)

    print("({}-{})/{} = {} {}".format(e,s,s,p,mline))


if __name__ == "__main__":
    main()


