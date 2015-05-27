#!/usr/bin/python
import pynotify
from mpd import MPDClient
from select import select
import urllib
import json
import os.path
import sys
# import pprint

HOST = 'localhost'
PORT = '6600'

ICON = '/usr/share/icons/HighContrast/48x48/devices/audio-headphones.png'
ICON48 = '/usr/share/icons/HighContrast/48x48/devices/audio-headphones.png'
ICON32 = '/usr/share/icons/HighContrast/32x32/devices/audio-headphones.png'

class SongNotify:

    def __init__(self):
        pynotify.init("mpd-notify")
        self.notify = pynotify.Notification("Music Player Daemon",
                "popup.pl", ICON)
        self.songstring=""

    def newSong(self, song):
        song.string = ""
        if not song.icon:
            song.icon = ICON
        for key in vars(song):
            at = getattr(song, key)
            if key in ["string", "id", "icon"]:
                continue
            if at:
                song.string += " ".join([key, ":", str(getattr(song, key)), "\n"])
                print(["key: ", key])
                print(["value: ", getattr(song, key)])

        if self.songstring == song.string:
            print("No Update")
            return

        if song.title and song.artist:
            # hello = pynotify.Notification(
            self.notify.update(
                str(song.title),
                str(song.string),
                song.icon)

        else:
            if isinstance(song.name, str) and isinstance(song.title, str):
                # hello = pynotify.Notification(
                self.notify.update(
                    str(song.name),
                    str(song.title),
                    ICON32)

            else:
                # hello = pynotify.Notification(
                self.notify.update(
                    "Music Player Daemon - Untitled Media",
                    str(song.string),
                    song.icon)

        print("['Notification: ', 'show']")
        self.notify.show()
        # hello.show()

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

    def __init__(self, host, port):
        self.client = MPDClient()

        try:
            self.client.connect(HOST, PORT)
        except SocketError:
            print("Failed to connect to MPD, exiting")
            sys.exit(1)
        self.notify = SongNotify()

        self.song = None
        self.updateSong(self.client.currentsong())

    def watch(self):
        while True:
            self.client.send_idle()
            select([self.client], [], [])
            changed = self.client.fetch_idle()
            for change in changed:
                print(["Change: ", change])
            # if set(changed).intersection(set(['player','playlist'])):
            if set(changed).intersection(set(['player'])):
                self.updateSong(self.client.currentsong())

    def updateSong(self, song):
        self.song = Song(song)

        print(["State: ", self.client.status()['state']])
        if self.client.status()['state'] == 'play':
            self.notify.newSong(self.song)


def test():
    client = MPDClient()
    notify = SongNotify()

    watch = MpdWatcher(HOST, PORT)
    watch.watch()

if __name__ == '__main__':
    test()
