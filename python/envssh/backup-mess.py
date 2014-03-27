#!/usr/bin/env python
# -*- coding: utf-8 -*-
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

from __future__ import unicode_literals, print_function
from pexpect import *
import time
import pxssh
import re
import struct
import fcntl
import termios
import signal
import sys
from docopt import docopt

__version__ = "0.1.0"
__author__ = "Justin Hoppensteadt"
__license__ = "MIT"


class jxssh(pxssh):

    def __init__(self, timeout=30, maxread=2000, searchwindowsize=None,
                 logfile=None, cwd=None, env=None, ssh_opts=None):
        spawn.__init__(self, None, timeout=timeout,
                       maxread=maxread,
                       searchwindowsize=searchwindowsize,
                       logfile=logfile, cwd=cwd, env=env)

        self.name = '<jxssh>'

        # used to match the command-line prompt
        self.UNIQUE_PROMPT = "\[PEXPECT\][\$\#] "
        self.PROMPT = self.UNIQUE_PROMPT

        # used to set shell command-line prompt to UNIQUE_PROMPT.
        self.PROMPT_SET_SH = "PS1='[PEXPECT]\$ '"
        self.PROMPT_SET_CSH = "set prompt='[PEXPECT]\$ '"
        self.SSH_OPTS = ssh_opts
        self.force_password = False
        self.auto_prompt_reset = True

    # TODO: This is getting messy and I'm pretty sure this isn't perfect.
    # TODO: I need to draw a flow chart for this.
    def login(self, ssh_opts, terminal_type='xterm',
              original_prompt=r"[#$]", login_timeout=10, port=None,
              auto_prompt_reset=True):
        """This logs the user into the given server. It uses the
        'original_prompt' to try to find the prompt right after login. When it
        finds the prompt it immediately tries to reset the prompt to something
        more easily matched. The default 'original_prompt' is very optimistic
        and is easily fooled. It's more reliable to try to match the original
        prompt as exactly as possible to prevent false matches by server
        strings such as the "Message Of The Day". On many systems you can
        disable the MOTD on the remote server by creating a zero-length file
        called "~/.hushlogin" on the remote server. If a prompt cannot be found
        then this will not necessarily cause the login to fail. In the case of
        a timeout when looking for the prompt we assume that the original
        prompt was so weird that we could not match it, so we use a few tricks
        to guess when we have reached the prompt. Then we hope for the best and
        blindly try to reset the prompt to something more unique. If that fails
        then login() raises an ExceptionPxssh exception.

        In some situations it is not possible or desirable to reset the
        original prompt. In this case, set 'auto_prompt_reset' to False to
        inhibit setting the prompt to the UNIQUE_PROMPT. Remember that pxssh
        uses a unique prompt in the prompt() method. If the original prompt is
        not reset then this will disable the prompt() method unless you
        manually set the PROMPT attribute. """

        cmd = "ssh " + ssh_opts

        # This does not distinguish between a remote server 'password' prompt
        # and a local ssh 'passphrase' prompt (for unlocking a private key).
        spawn._spawn(self, cmd)
        i = self.expect(
            ["(?i)are you sure you want to continue connecting",
                original_prompt, "(?i)(?:password)|(?:passphrase for key)",
                "(?i)permission denied", "(?i)terminal type", TIMEOUT,
                "(?i)connection closed by remote host"],
            timeout=login_timeout)

        # First phase
        if i == 0:
            # New certificate -- always accept it.
            # This is what you get if SSH does not have the remote host's
            # public key stored in the 'known_hosts' cache.
            self.sendline("yes")
            i = self.expect(
                ["(?i)are you sure you want to continue connecting",
                    original_prompt,
                    "(?i)(?:password)|(?:passphrase for key)",
                    "(?i)permission denied", "(?i)terminal type",
                    TIMEOUT])
        if i == 2:  # password or passphrase
            self.sendline(password)
            i = self.expect(
                ["(?i)are you sure you want to continue connecting",
                    original_prompt,
                    "(?i)(?:password)|(?:passphrase for key)",
                    "(?i)permission denied", "(?i)terminal type",
                    TIMEOUT])
        if i == 4:
            self.sendline(terminal_type)
            i = self.expect(
                ["(?i)are you sure you want to continue connecting",
                    original_prompt,
                    "(?i)(?:password)|(?:passphrase for key)",
                    "(?i)permission denied", "(?i)terminal type", TIMEOUT])

        # Second phase
        if i == 0:
            # This is weird. This should not happen twice in a row.
            self.close()
            raise ExceptionPxssh(
                'Weird error. Got "are you sure" prompt twice.')
        # can occur if you have a public key pair set to authenticate.
        elif i == 1:
            # TODO: May NOT be OK if expect() got tricked and matched a false
            # prompt.
            pass
        elif i == 2:  # password prompt again
            # For incorrect passwords, some ssh servers will
            # ask for the password again, others return 'denied' right away.
            # If we get the password prompt again then this means
            # we didn't get the password right the first time.
            self.close()
            raise ExceptionPxssh('password refused')
        elif i == 3:  # permission denied -- password was bad.
            self.close()
            raise ExceptionPxssh('permission denied')
        elif i == 4:  # terminal type again? WTF?
            self.close()
            raise ExceptionPxssh(
                'Weird error. Got "terminal type" prompt twice.')
        elif i == 5:  # Timeout
            pass
        elif i == 6:  # Connection closed by remote host
            self.close()
            raise ExceptionPxssh('connection closed')
        else:  # Unexpected
            self.close()
            raise ExceptionPxssh('unexpected login response')
        if not self.sync_original_prompt():
            self.close()
            raise ExceptionPxssh('could not synchronize with original prompt')
        # We appear to be in.
        # set shell prompt to something unique.
        if auto_prompt_reset:
            if not self.set_unique_prompt():
                self.close()
                raise ExceptionPxssh(
                    'could not set shell prompt\n' + self.before)
        return True


def sigwinch_passthrough(sig, data):
    s = struct.pack("HHHH", 0, 0, 0, 0)
    a = struct.unpack('hhhh', fcntl.ioctl(sys.stdout.fileno(),
                                          termios.TIOCGWINSZ, s))
    #child.setwinsize(a[0], a[1])


def main():
    '''Main entry point for the envssh CLI.'''
    args = docopt(__doc__, version=__version__)
    print(args)
    #child = pexpect.spawn('ssh ' + " ".join(args['SSH_OPTIONS']))
    # child.expect(r'[$#]')
    child = jxssh.jxssh()
    try:
        for ENV in re.split(r'\s+', args['--environment']):
            if re.match(r'\D\w+=\w+', ENV):
                pass
                # child.sendline(ENV)
    except KeyError:
        pass

    signal.signal(signal.SIGWINCH, sigwinch_passthrough)
    # child.interact()


if __name__ == '__main__':
    main()
