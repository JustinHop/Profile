#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''tweet-poc

Usage:
  tweet-poc [options] <command> <user>

Options:
  -h --help       Show this screen.
  --version       Show version.
  --apikey=<key>  Speed in knots [default: 10].

The most commly used tweet-poc commands are:
  getfriendids <user>...   Get following ids
  getfollowids <user>...   Get followers ids
  getfollowidsbyid <id>... Get followers ids by userid
  getuserbyid <id>...      Get user info by userid
  getuserbyname <user>...  Get user info by name
'''

from __future__ import unicode_literals, print_function
from docopt import docopt

import twitter
import time
import pickle
import yaml
import os

__version__ = "0.1.0"
__author__ = "Justin Hoppensteadt"
__license__ = "MIT"

functions = ["getfriendids", "getfollowids",
             "getfollowidsbyid", "getuserbyid", "getuserbyname"]


def login():
    '''Test login with twitter creds'''
    creds = {}
    with open(os.environ["HOME"] + "/twitter.api", "r") as stream:
        creds = yaml.load(stream)
    creds = creds['twitter']
    api = twitter.Api(
        consumer_key=creds['consumer_key'],
        consumer_secret=creds['consumer_secret'],
        access_token_key=creds['access_token_key'],
        access_token_secret=creds['access_token_secret'])
    return api


def makeyaml(name, data):
    stamp = time.strftime("%FT%T")
    print(stamp)
    logdir = '/home/justin/Profile/python/tweet-poc/log/'
    log = logdir + stamp + "-" + name + ".yaml"
    print(data)
    yaml.dump(data, open(log, "w"))
    print(log)


def makepickle(data):
    stamp = time.strftime("%FT%T")
    print(stamp)
    logdir = '/home/justin/Profile/python/tweet-poc/log/'
    log = logdir + stamp + ".pickle"
    pickle.dump(str(data), open(log, "w"))
    print(log)


def getfriends(api, user):
    friends = api.GetFriends(screen_name=user)
    makeyaml("getfriends", friends)


def getfriendids(api, user):
    friends = api.GetFriends(screen_name=user)
    makeyaml("getfriendids", friends)


def getfollowids(api, user):
    friends = api.GetFollowerIDs(screen_name=user, total_count=150000)
    makeyaml("getfollowids", friends)


def main():
    '''Main entry point for the tweet-poc CLI.'''
    args = docopt(__doc__, version=__version__)
    print(args)
    user = args['<user>']
    command = args['<command>']
    T = login()
    print(T.VerifyCredentials())

    actions = {"getfriendids": getfriendids(T, user),
               "getfollowids": getfollowids(T, user),
               "getfollowidsbyid": print(T, user),
               "getuserbyid": print(T, user),
               "getuser": print(T, user),
               }
    actions[command]()


if __name__ == '__main__':
    main()
