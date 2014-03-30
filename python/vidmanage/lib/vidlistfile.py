#from options import Options
from datetime import datetime
import pickle
import os
import sys


class Vid:

    def __init__(self, videofile):
        self.v = {'filename': videofile, 'timeadded': datetime.now()}
        self.attr()
        print self.v['filename'], self.gethumansize()

    def attr(self):
        self.v['filename'] = os.path.realpath(self.v['filename'])
        self.v['directory'] = os.path.dirname(self.v['filename'])
        self.v['stat'] = os.stat(self.v['filename'])

    def deletefile(self):
        print "DELETING", self.v['filename']
        os.remove(self.v['filename'])

    def gettimeadded(self):
        return self.v['timeadded']

    def getattr(self):
        return self.v

    def getname(self):
        return self.v['filename']

    def getsize(self):
        return self.v['stat'].st_size

    def gethumansize(self):
        for num in [self.getsize()]:
            for x in ['bytes', 'KB', 'MB', 'GB', 'TB']:
                if num < 1024.0:
                    return "%3.1f %s" % (num, x)
                num /= 1024.0


class VidList:

    def __init__(self):
        self._init_vidlist()

    def _init_vidlist(self):
        self.videolist = []

    def append(self, argfilename):
        for vid in self.videolist:
            if vid.getname() == argfilename:
                raise Exception("File Already In List")
        self.videolist.append(Vid(argfilename))

    def append_obj(self, argVidobj):
        self.videolist.append(argVidobj)

    def remove(self, argfilename):
        for vid in self.videolist:
            if vid.getname() == argfilename:
                self.videolist.remove(vid)
                return
        raise Exception(argfilename + " does not exist in list")

    def remove_obj(self, argVidobj):
        self.videolist.remove(argVidobj)

    def getlist(self):
        return self.videolist

    def printlist(self):
        for vid in self.videolist:
            print vid.getname(), vid.gethumansize()

    def prettyprintlist(self):
        self.totalbytes = 0
        for vid in self.videolist:
            print vid.getname(), vid.gethumansize()
        print "Total:", self.gethumansize()

    def getsize(self):
        totalbytes = 0
        for vid in self.videolist:
            totalbytes += vid.getsize()
        return totalbytes

    def gethumansize(self):
        for num in [self.getsize()]:
            for x in ['bytes', 'KB', 'MB', 'GB', 'TB']:
                if num < 1024.0:
                    return "%3.1f %s" % (num, x)
                num /= 1024.0


class VidDList(VidList):

    def purgelist(self):
        print "Removing", self.gethumansize(), "of data."
        for vid in self.videolist:
            vid.deletefile()
            self.remove_obj(vid)

    def printlist(self):
        for vid in self.videolist:
            print vid.getname(), vid.gethumansize()


class VidListFull:

    def __init__(self):
        self.Dlist = VidDList()
        self.Alist = VidList()

    def dlist(self):
        return self.Dlist

    def alist(self):
        return self.Alist

    def setdlist(self, dlist):
        self.Dlist = dlist

    def setalist(self, alist):
        self.Alist = alist


class VidListFile:

    def __init__(self, argfilename):
        self.filename = argfilename
        self.load()

    def load(self):
        try:
            self.vidlistfull = pickle.load(open(self.filename))
        except IOError:
            self.vidlistfull = VidListFull()
        return self.vidlistfull

    def save(self):
        pickle.dump(self.vidlistfull, open(self.filename, "w"))