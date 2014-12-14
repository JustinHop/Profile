#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''nsrmigrate

Usage:
  nsrmigrate [options] [FILE...]
  nsrmigrate -h | --help
  nsrmigrate --version

Options:
  -i            Change file inplace, like sed.
  -f --from     String in fqdn to change from
  -t --to       String in fqdn to change to
  -n --name     Resolve names only
  -a --addr     Resolve addrs only
  -d            Debugging output
  -V            Verbose operation
  -h --help     Show this screen.
  --version     Show version.
'''

from __future__ import unicode_literals, print_function
from docopt import docopt
import fileinput
import re

__version__ = "0.1.0"
__author__ = "Justin Hoppensteadt"
__license__ = "MIT"


def splitline(line=""):
    words = r'\w+'
    ip = re.compile(('^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.)'
        '{3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'))
    host = r'^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)\
        *([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])'
    char = r'\S'
    ws = r'\s+'
    ip = ip
    chunker = re.compile('({}|{}|{}|{})'.format(words, host, char, ws))

    for chunk in re.match(chunker, line):
        try:
            print("".join("[", chunk, "]"))
        except:
            pass


def main():
    '''Main entry point for the nsrmigrate CLI.'''
    args = docopt(__doc__, version=__version__)
    print(args)
    for line in fileinput.input(args['FILE']):
        line = line.rstrip()
        if args['-V']:
            print (line)
        splitline(line)

if __name__ == '__main__':
    main()
