#!/usr/bin/env python
'''dnsflip
Usage:
    dnsflip (--forward|--reverse) [options]
    dnsflip ([--output-file=LOGFILE] [<FILE>...])
    dnsflip [--]
    dnsflip ship <name> move <x> <y> [--speed=<kn>]
    dnsflip ship shoot <x> <y>
    dnsflip mine (set|remove) <x> <y> [--moored|--drifting]
    dnsflip -h | --help
    dnsflip --version

Options:
    -o --output-file=LOGFILE  Output file [default: -].
    -f --forward              Only preform forward lookups.
    -r --reverse              Only preform reverse lookups.
    -v --version              Show version.
    -h --help                 Show this screen.
'''

#from __future__ import unicode_literals, print_function
from docopt import docopt
import fileinput
import re

__version__ = "0.1.0"
__author__ = "Justin Hoppensteadt"
__license__ = "MIT"


class DNSFlip:

    #import socket

    '''The DNS Flipper'''

    def __init__(self):
        self.ValidIp = re.compile(
            r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
            r'(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}')
        self.ValidIpNoArpa = re.compile(
            r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
            r'(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}'
            r'(?!(\d+)*\.in-addr\.arpa\.?)')
        self.ValidArpa = re.compile(
            r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
            r'(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}'
            r'.in-addr\.arpa\.?')
        self.ValidHost = re.compile(
            r'(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)'
            r'*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])')
        self.CommonHost = re.compile(
            r'(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)'
            r'*(com|org|net|info|tmcs|pl|tv)\.?', re.IGNORECASE)

    def strip(self, stringIn):
        self.stripedLine = []
        self.inputString = stringIn
        for word in stringIn.split():
            if (self.ValidArpa.match(word) or
                self.ValidIp.match(word) or
                    self.CommonHost.match(word)):
                        self.stripedLine.append(word)
        return " ".join(self.stripedLine)

    def arpa(self, stringIn):
        self.inputString = stringIn
        return self.ValidArpa.subn("<PTR-RECORD>", self.inputString)[0]

    def forward(self, stringIn):
        self.inputString = stringIn
        return self.ValidIpNoArpa.subn("<IP-ADDRESS>", self.inputString)[0]

    def reverse(self, stringIn):
        self.inputString = stringIn
        return self.CommonHost.subn("<HOSTNAME>", self.inputString)[0]

    def flip(self, stringIn):
        self.inputStringFull = self.arpa(stringIn)
        self.inputStringFull = self.forward(self.inputStringFull)
        return self.reverse(self.inputStringFull)


def main():
    '''Main entry point for the dnsflip CLI.'''
    args = docopt(__doc__, version=__version__)
    print(args)
    dnsf = DNSFlip()
    for line in fileinput.input(args['<FILE>']):
        line = line.rstrip()
        print (line)
        print (dnsf.flip(line))
        print (dnsf.strip(line))


if __name__ == '__main__':
    main()
