#import sys
import os
#import pickle
import pynotify

#from datetime import datetime
#from pprint import pprint

from lib import Vid, VidListFile
#VidList, VidListFull, VidDList
from lib import Options
from lib import FindVideo

if __name__ == '__main__':
    options = Options()
    opts = options.parse()

    vidlistfile = VidListFile(opts.listfile)
    fulllist = vidlistfile.load()

    pynotify.init("image")

    fv = FindVideo()
    video = opts.testfile or fv.getvideo()

    if opts.alist:
        if not video:
            raise Exception("No video file detected or specified.")
        if opts.remove:
            fulllist.alist().remove(video)
        else:
            v = Vid(video)
            videoinformation = v.getname(), v.gethumansize()
            if opts.notify:
                notify = pynotify.Notification(
                    "VidManager - Appending to Alist",
                    str(videoinformation),
                    os.path.dirname(
                        os.path.realpath(__file__)) +
                    "/vidmanage.png")
                notify.show()
            fulllist.alist().append(video)
    elif opts.klist:
        if not video:
            raise Exception("No video file detected or specified.")
        if opts.remove:
            fulllist.klist().remove(video)
        else:
            v = Vid(video)
            videoinformation = v.getname(), v.gethumansize()
            if opts.notify:
                notify = pynotify.Notification(
                    "VidManager - Appending to Klist",
                    str(videoinformation),
                    os.path.dirname(
                        os.path.realpath(__file__)) +
                    "/vidmanage.png")
                notify.show()
            fulllist.klist().append(video)
    elif opts.dlist:
        if not video:
            raise Exception("No video file detected or specified.")
        if opts.remove:
            fulllist.dlist().remove(video)
        else:
            v = Vid(video)
            videoinformation = v.getname(), v.gethumansize()
            if opts.notify:
                notify = pynotify.Notification(
                    "VidManager - Appending to Delete List",
                    str(videoinformation),
                    os.path.dirname(
                        os.path.realpath(__file__)) +
                    "/vidmanage.png")
                notify.show()
            fulllist.dlist().append(video)
    elif opts.remove:
        if not video:
            raise Exception("No video file detected or specified.")
        v = Vid(video)
        videoinformation = v.getname(), v.gethumansize()
        if opts.notify:
            notify = pynotify.Notification("VidManager - Removing from lists",
                                           str(videoinformation),
                                           os.path.dirname(
                                               os.path.realpath(__file__)) +
                                           "/vidmanage.png")
            notify.show()
        fulllist.alist().remove(video)
        fulllist.klist().remove(video)
        fulllist.dlist().remove(video)
    elif opts.info:
        print "A List"
        fulllist.alist().prettyprintlist()
        print "K List"
        fulllist.klist().prettyprintlist()
        print "D List"
        fulllist.dlist().prettyprintlist()
    elif opts.videoinfo:
        if not video:
            raise Exception("No video file detected or specified.")
        v = Vid(video)
        videoinformation = v.getname(), v.gethumansize()
            #datetime.fromtimestamp(v.getattr()['stat'][-1])
        if opts.notify:
            notify = pynotify.Notification("VidManager - Information",
                                           str(videoinformation),
                                           os.path.dirname(
                                               os.path.realpath(__file__)) +
                                           "/vidmanage.png")
            notify.show()
        else:
            print str(videoinformation)
    elif opts.output:
        for v in fulllist.alist().getlist():
            print v.getname()
    elif opts.outputall:
        for v in fulllist.alist().getlist():
            print v.getname()
        for v in fulllist.klist().getlist():
            print v.getname()
    elif opts.purgelist:
        fulllist.dlist().purgelist()

    if not opts.dryrun:
        vidlistfile.save()
