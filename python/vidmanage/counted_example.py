#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Usage: counted_example.py --help
       counted_example.py [<file>...]

"""
from docopt import docopt

import cPickle as pickle

import pprint

if __name__ == '__main__':
    args = docopt(__doc__,
                  version='0.1.0')

    print(args)

    for f in args['<file>']:
        pp = pprint.PrettyPrinter(indent=4)
        v = pickle.load(open(f, "rb"))
        d = v.dlist()
        d.printlist()
