#!/usr/bin/env python
'''envssh

Usage:
  envssh [options] SSH_OPTIONS...
  envssh -h | --help
  envssh --version

Arguements:
  SSH_OPTIONS   options to be passed to ssh.

Options:
  -e, --environment=ENVIRONMENT     Set environment variables as stated
                                    in ENVIRONMENT.
  -E, --envfile=ENVFILE             Set environment contained in ENVFILE.
  -r, --remote=COMMAND              Execute COMMAND on remote system.
  -s, --script=SHFILE               Execute SHFILE on remote system.
  -h --help                         Show this screen.
  --version                         Show version.
'''

#from __future__ import unicode_literals, print_function
#from pexpect import *
import traceback
import pexpect
import re
import struct
import fcntl
import termios
import signal
import sys
import os
#import time
#import errno
from docopt import docopt

__version__ = "0.1.0"
__author__ = "Justin Hoppensteadt"
__license__ = "MIT"

global_pexpect_instance = None


def main():
    '''Main entry point for the envssh CLI.'''
    args = docopt(__doc__, version=__version__)
    print(args)

    p = pexpect.spawn('ssh ' + " ".join(args['SSH_OPTIONS']))
    p.waitnoecho()
    global global_pexpect_instance
    global_pexpect_instance = p
    signal.signal(signal.SIGWINCH, sigwinch_passthrough)

    p.expect(r'[$#]')
    try:
        for ENV in re.split(r'\s+', args['--environment']):
            if re.match(r'\D\w+=\w+', ENV):
                p.sendline("export " + ENV)
    except TypeError:
        pass
    except KeyError:
        pass
    try:
        for line in open(args['--envfile'], "r"):
            p.send(line)
    except IOError:
        pass
    sigwinch_passthrough(None, None)
    try:
        p.interact(chr(29))
    except OSError:
        pass


def sigwinch_passthrough(sig, data):

    # Check for buggy platforms (see pexpect.setwinsize()).
    if 'TIOCGWINSZ' in dir(termios):
        TIOCGWINSZ = termios.TIOCGWINSZ
    else:
        TIOCGWINSZ = 1074295912  # assume
    s = struct.pack("HHHH", 0, 0, 0, 0)
    a = struct.unpack('HHHH', fcntl.ioctl(sys.stdout.fileno(), TIOCGWINSZ, s))
    global global_pexpect_instance
    global_pexpect_instance.setwinsize(a[0], a[1])

if __name__ == '__main__':
    try:
        main()
    except SystemExit, e:
        raise e
    except Exception, e:
        print "ERROR"
        print str(e)
        traceback.print_exc()
        os._exit(1)
