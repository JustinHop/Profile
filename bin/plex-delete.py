#!/usr/bin/python

from pprint import pprint
from plexapi.server import PlexServer
# from plexapi.server import MyPlexAccount
import os
import datetime

user = 'justinplexxx'
passwd = 'supereasy1'
baseurl = 'http://localhost:32400'
token = 'EzMR9a8xTSKQVcwvDRF2'

plex = PlexServer(baseurl, token)

# account = MyPlexAccount.signin(user, passwd)
# plex = account.resource('localhost').connect()

keep = []
kept = 0
deleted = 0

print('-----------------------------------------------')
print(
    'Running Plex Cleaner on ' +
    datetime.datetime.now().strftime('%m/%d/%Y %H:%M:%S'))
print('')

for section in plex.library.sections():
    pprint(section)
    print(dir(section))

    for video in section.search(unwatched=False):
        pprint(video)
        print(dir(video))
        print(video)
        print(video.title, video.location)


# for entry in plex.library.section('TV Shows').unwatched():
#     if entry.grandparentTitle not in keep:
#         print('Deleting '+entry.title+' '+entry.media[0].parts[0].file)
#         deleted += 1
#         if False:
#             os.remove(entry.media[0].parts[0].file)
#
#     else:
#         print('Keeping '+entry.title+' '+entry.media[0].parts[0].file)
#         kept += 1

print('')
print(str(kept) + ' Episodes Kept')
print(str(deleted) + ' Episodes Deleted')
