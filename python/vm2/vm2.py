#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''vm2

Usage:
  vm2 [options] rate <rateing> <file>
  vm2 [options] unrate <file>
  vm2 [options] query <file>
  vm2 [options] list <rateing>
  vm2 [options] purge
  vm2 -h | --help
  vm2 --version

Options:
  -D --debug            Enable debugging output.
  -d, --database DBFILE
        [default: ~/.config/vm2/db.sqlite]
                        Set location of sqlite db.
  -n --dryrun           Take no action.
  -N --notify           Enable libnotify popups.
  -v --verbose          Show verbose output.
  -h --help             Show this screen.
  -V --version          Show version.

Ratings:
    1                   Delete
    2                   Shitty
    3                   Keep
    4                   Good
    5                   Finisher
'''

from __future__ import unicode_literals, print_function
from docopt import docopt

import os

__version__ = "0.1.0"
__author__ = "Justin Hoppensteadt"
__license__ = "MIT"


def dbinit(args):
    dbfile = os.path.expanduser(args['--database'])
    dbdir = os.path.dirname(dbfile)
    if not os.path.isdir(dbdir):
        os.makedirs(dbdir)


def debugs(args, s):
    if args['--debug']:
        print(s)


def main():
    '''Main entry point for the vm2 CLI.'''
    args = docopt(__doc__, version=__version__)
    debugs(args, args)
    dbinit(args)

if __name__ == '__main__':
    main()
