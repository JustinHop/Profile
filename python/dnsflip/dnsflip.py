#!/usr/bin/env python
'''dnsflip
Usage:
    dnsflip [-frV1As] [FILE...]
    dnsflip -h | --help
    dnsflip --version

Options:
    -A --all                  All addresses
    -s --strip                Strip non host info from lines
    -f --noforward            Do not preform forward lookups.
    -r --noreverse            Do not preform reverse lookups.
    -V --verbose              Be verbose, print extra lines
    -1 --oneline              Output one line with resolution after.
    -v --version              Show version.
    -h --help                 Show this screen.
'''

#from __future__ import unicode_literals, print_function
from docopt import docopt
import dns.resolver
import dns.reversename
#import string
import fileinput
import re

__version__ = "0.2.0"
__author__ = "Justin Hoppensteadt"
__license__ = "MIT"


class DNSFlip:

    '''The DNS Flipper'''

    def __init__(self):
        self.args = docopt(__doc__, version=__version__)
        self.ValidIp = re.compile(
            r'((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
            r'(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3})')
        self.ValidIpNoArpa = re.compile(
            r'((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
            r'(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}'
            r'(?!(\d+)*\.in-addr\.arpa\.?))')
        self.ValidArpa = re.compile(
            r'((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
            r'(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}'
            r'.in-addr\.arpa\.?)')
        self.ValidHost = re.compile(
            r'(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)'
            r'*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])')
        self.CommonHost = re.compile(
            r'((([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)'
            r'*(au|mx|ca|nz|uk|com|org|net|info|tmcs|pl|tv)\b)',
            re.IGNORECASE)

    def strip(self, stringIn):
        self.stripedLine = []
        self.inputString = stringIn
        for word in stringIn.split():
            if (self.ValidArpa.match(word) or
                self.ValidIp.match(word) or
                    self.CommonHost.match(word)):
                        self.stripedLine.append(word)
        return " ".join(self.stripedLine)

    def _resolve_r(self, ipaddr):
        self.ipv4 = ipaddr.group()
        #print self.ipv4
        self.rev = dns.reversename.from_address(self.ipv4)
        try:
            if (self.args['--all']):
                return ",".join(dns.resolver.query(self.rev, "PTR"))
            else:
                return str(dns.resolver.query(self.rev, "PTR")[0])
        except dns.resolver.NXDOMAIN:
            return str(self.ipv4)
        #return dns.reversename.to_address(self.rev)

    def _resolve(self, hostname):
        self.host = str(hostname.group())
        try:
            self.answers = dns.resolver.query(hostname.group(),
                                              'A')
            if (self.args['--all']):
                ansstr = []
                for an in self.answers:
                    ansstr.append(an.__str__())
                return ",".join(ansstr)
            else:
                return self.answers[0].__str__()
        except dns.resolver.NXDOMAIN:
            return self.host

    def arpa(self, stringIn):
        self.inputString = stringIn
        return self.ValidArpa.subn("<PTR-RECORD>",
                                   self.inputString)[0]

    def reverse(self, stringIn):
        self.inputString = stringIn
        self._rev = self.ValidIpNoArpa.subn(self._resolve_r,
                                            self.inputString)[0]
        return self._rev

    def forward(self, stringIn):
        self.inputString = stringIn
        self._rev = self.CommonHost.subn(self._resolve,
                                         self.inputString)[0]
        #print self._rev
        return self._rev
        # return self.CommonHost.subn("<HOSTNAME>", self.inputString)[0]

    def parse(self, stringIn):
        self.lineout = []
        for chunk in re.findall(r'(\s+|\S+)', stringIn):
            self.chunkout = ""
            if (self.CommonHost.match(chunk)):
                if (self.args['--noforward']):
                    self.lineout.append(chunk)
                else:
                    self.chunkout = self.forward(chunk)
            elif (self.ValidIpNoArpa.match(chunk)):
                if (self.args['--noreverse']):
                    self.lineout.append(chunk)
                else:
                    self.chunkout = self.forward(chunk)
            else:
                if (self.args['--strip']):
                    continue
                else:
                    self.lineout.append(chunk)
                continue
            if (self.args['--oneline']):
                self.lineout.append(chunk + '[' + self.chunkout + ']')
            else:
                self.lineout.append(self.chunkout)
        if (self.args['--strip']):
            return " ".join(self.lineout)
        else:
            return "".join(self.lineout)

    def flip(self, stringIn):
        self.inputStringFull = self.forward(stringIn)
        #self.inputStringFull = self.forward(self.inputStringFull)
        return self.reverse(self.inputStringFull)


def main():
    '''Main entry point for the dnsflip CLI.'''
    args = docopt(__doc__, version=__version__)
    #print(args)
    dnsf = DNSFlip()
    for line in fileinput.input(args['FILE']):
        line = line.rstrip()
        if (args['--verbose']):
            print (line)
        print (dnsf.parse(line))
        #print (dnsf.strip(line))


if __name__ == '__main__':
    main()
