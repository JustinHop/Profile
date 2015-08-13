#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''tweet-poc

Usage:
  tweet-poc
  tweet-poc info <user>...
  tweet-poc -h | --help
  tweet-poc --version

Options:
  -h --help       Show this screen.
  --version       Show version.
  --apikey=<key>  Speed in knots [default: 10].
'''

from __future__ import unicode_literals, print_function
from docopt import docopt

import twitter

__version__ = "0.1.0"
__author__ = "Justin Hoppensteadt"
__license__ = "MIT"


def login():
    '''Test login with twitter creds'''
    api = twitter.Api(
        consumer_key='9JzfeNEIXb7NMucDOp7IIUazF',
        consumer_secret='m94m4HAjN7ViqOM78H23VlPDBqJUMJ8Yf3uwY2cXgGkYRNIvny',
        access_token_key='3313853280-b3LZTCe8etMew9x5yQ89WoQaqVUVx9TQ9LP0hOj',
        access_token_secret='lzoFB3Vf7GmQjIXyQmJBRj0I4D4qH1BeADEIgbEq8XwoV')
    return api


def getfriends(api, user):
    friends = api.GetFriends(screen_name=user)
    for friend in friends:
        print(friend)


def main():
    '''Main entry point for the tweet-poc CLI.'''
    args = docopt(__doc__, version=__version__)
    print(args)
    T = login()
    print(T.VerifyCredentials())
    getfriends(T, 'trmnlfreq')
    # users = T.GetUsersSearch('trmnlfreq')
    # for user in users:
    #    print(user)


if __name__ == '__main__':
    main()
