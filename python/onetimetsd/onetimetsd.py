#!/usr/bin/env python
'''onetimetsd

Usage:
  onetimetsd [-nD] <FILE>...
  onetimetsd -h | --help
  onetimetsd --version

Options:
  -n --dry-run  No action
  -D --debug    Debug
  -h --help     Show this screen.
  --version     Show version.
'''

from docopt import docopt

__version__ = "0.1.0"
__author__ = "Justin Hoppensteadt"
__license__ = "MIT"


class Nsr2TSD:

    """Does the conversion, expects file opj"""

    def __init__(self):
        self.args = docopt(__doc__, version=__version__)
        if (self.args['--debug']):
            print ("Nsr2TSD Class Created")
        self.data = {}

    def add(self, fobj):
        self.f = fobj
        try:
            print(self.f.readline())
        except IOError:
            print("Not a file")


def main():
    '''Main entry point for the onetimetsd CLI.'''
    args = docopt(__doc__, version=__version__)
    if (args['--debug']):
            print(args)
    NS = Nsr2TSD()
    for file in args['<FILE>']:
        try:
            f = open(file, 'r')
            NS.add(f)
        except IOError:
            print("can not read ", file)

if __name__ == '__main__':
    main()
