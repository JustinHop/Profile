import pexpect
import struct
import fcntl
import termios
import signal
import sys


def sigwinch_passthrough(sig, data):
    s = struct.pack("HHHH", 0, 0, 0, 0)
    a = struct.unpack('hhhh',
                      fcntl.ioctl(sys.stdout.fileno(), termios.TIOCGWINSZ, s))
    global p
    p.setwinsize(a[0], a[1])
p = pexpect.spawn('/bin/bash')
signal.signal(signal.SIGWINCH, sigwinch_passthrough)
p.interact()
