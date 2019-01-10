#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''popup.py

Usage: popup.py [options]

Options:
    -h HOST, --host=HOST    MPD host to connect to [default: localhost]
    -p PORT, --port=PORT    Port on host to connect to [default: 6600]
    -v, --verbose           Be loud [default: False]
    -1                      Oneshot

'''

import pynotify
from mpd import MPDClient
from select import select
import urllib
import json
import os.path
import sys
import time
import signal, os
# import pprint
from docopt import docopt

ICON = '/usr/share/icons/HighContrast/48x48/devices/audio-headphones.png'
ICON48 = '/usr/share/icons/HighContrast/48x48/devices/audio-headphones.png'
ICON32 = '/usr/share/icons/HighContrast/32x32/devices/audio-headphones.png'

class SongNotify:
    def __init__(self, verbose=False):
        self.verbose = verbose
        pynotify.init("mpd-notify")
        self.notify = pynotify.Notification("Music Player Daemon",
                "popup.pl", ICON48)
        self.songstring=""

    def newSong(self, song):
        song.string = ""
        if not song.icon:
            song.icon = ICON48
        for key in vars(song):
            at = getattr(song, key)
            if key in ["string", "id", "icon"]:
                continue
            if at:
                song.string += " ".join([key, ":", str(getattr(song, key)), "\n"])
                if self.verbose == True:
                    print(["key: ", key])
                    print(["value: ", getattr(song, key)])

        if self.songstring == song.string:
            if self.verbose == True:
                print("No Update")
            return

        if song.title and song.artist:
            self.notify.update(
                str(song.title),
                str(song.string),
                song.icon)

        else:
            if isinstance(song.name, str) and isinstance(song.title, str):
                self.notify.update(
                    str(song.name),
                    str(song.title),
                    ICON48)

            else:
                self.notify.update(
                    "Music Player Daemon - Untitled Media",
                    str(song.string),
                    song.icon)

        try:
            if self.verbose == True:
                print("['Notification: ', 'show']")
            self.notify.show()
        except glib.GError:
            print("['Notification: ', 'failed']")

LASTFMAPIKEY = "e5d743dba724b90c0e522ad8ea7b4afc"


class Song:
    def __init__(self, song_dict):
        for d in ['id', 'album', 'artist', 'title', 'name', 'file']:
            if d in song_dict:
                setattr(self, d, song_dict[d])
            else:
                setattr(self, d, None)

        self.icon = None

        self.mbid = None

        self.fetch_lastfm()

    def fetch_lastfm(self):
        addedinfo = False
        url = "".join(
            ["http://ws.audioscrobbler.com/2.0/?method=track.getinfo",
             "&api_key=", LASTFMAPIKEY, "&format=json"])
        if self.mbid:
            url += "&mbid=%s" % self.mbid
            addedinfo = 1
        if self.artist:
            url += "&artist=%s" % self.artist
            addedinfo = 1
        if self.title:
            url += "&title=%s" % self.title
            addedinfo = 1

        if not (addedinfo):
            if self.name:
                url += "&title=%s" % self.name
                addedinfo = 1

        response = urllib.urlopen(url)
        try:
            song_dict = json.loads(response.read())["track"]
            self.albumid = song_dict["album"]["mbid"]
            self.icon = self.fetch_albumart(
                song_dict["album"]["image"][0]["#text"])
        except ValueError:
            song_dict = {}
        except KeyError:
            song_dict = {}

    def fetch_albumart(self, location):
        file_location = "/tmp/" + self.album
        if not os.path.isfile(file_location):
            response = urllib.urlopen(location)

            file_obj = open(file_location, "w")
            file_obj.write(response.read())
            file_obj.close()

        return file_location


class MpdWatcher:
    def __init__(self, host, port, verbose=False, once=False):
        self.client = MPDClient()
        self.verbose = verbose

        #try:
        #    self.client.connect(HOST, PORT)
        #except:
        #    print("Failed to connect to MPD")
        while True:
            try:
                self.client.connect(host, port)
                break
            except BaseException as e:
                print('MpdWatcher failed connecting to %s:%s: %s' % (host, port, e))
                if once:
                    sys.exit()
                time.sleep(1)
        self.notify = SongNotify(verbose=self.verbose)

        self.song = None
        self.updateSong(self.client.currentsong())

    def watch(self):
        while True:
            self.client.send_idle()
            select([self.client], [], [])
            changed = self.client.fetch_idle()
            for change in changed:
                if self.verbose == True:
                    print(["Change: ", change])
            # if set(changed).intersection(set(['player','playlist'])):
            if set(changed).intersection(set(['player'])):
                self.updateSong(self.client.currentsong())

    def once(self):
        self.updateSong(self.client.currentsong())

    def updateSong(self, song):
        self.song = Song(song)

        if self.verbose == True:
            print(["State: ", self.client.status()['state']])
        if self.client.status()['state'] == 'play':
            self.notify.newSong(self.song)


def main():
    conf = docopt(__doc__)
    try:
        if conf['--verbose'] == True:
            print(conf)
    except BaseException as e:
        pass

    if conf['-1']:
        client = MPDClient()
        notify = SongNotify()
        watch = MpdWatcher(conf['--host'], conf['--port'], conf['--verbose'], once=True)
        sys.exit()
    while True:
        try:
            client = MPDClient()
            notify = SongNotify(conf['--verbose'])
            watch = MpdWatcher(conf['--host'], conf['--port'], conf['--verbose'])
            watch.watch()
        except BaseException as e:
            print('main() Failed connecting to %s:%s: %s' % (conf['--host'], conf['--port'], e))
            time.sleep(1)

def handle(signum, frame):
    print('Exiting')
    sys.exit(0)

def hup(signum, frame):
    python = sys.executable
    os.execl(python, python, *sys.argv)

    #client = MPDClient()
    #notify = SongNotify()
    #watch = MpdWatcher(conf['--host'], conf['--port'], once=True)
    #sys.exit()


signal.signal(signal.SIGHUP, hup)
signal.signal(signal.SIGUSR2, hup)
signal.signal(signal.SIGUSR1, hup)
signal.signal(signal.SIGTERM, handle)
if __name__ == '__main__':
    main()
