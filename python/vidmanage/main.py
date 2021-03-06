# Author: Justin Hoppensteadt <py@justinhoppensteadt.com>
# Copyright: BSD

# import sys
import os
import warnings
# import pickle
import notify2

# from datetime import datetime
# from pprint import pprint

from lib import Vid, VidListFile
# VidList, VidListFull, VidDList
from lib import Options
from lib import FindVideo

base = '/mnt/auto/1/share/Video'
base2 = '/mnt/auto/4/share/Video'

if __name__ == '__main__':
    options = Options()
    opts = options.parse()

    vidlistfile = VidListFile(opts.listfile)
    fulllist = vidlistfile.load()

    notify2.init("vidmanage")

    videos = []

    fv = FindVideo()

    if isinstance(opts.FILE, list):
        videos = opts.FILE
    elif isinstance(opts.FILE, str):
        videos.append(opts.FILE)
    else:
        videos.append(fv.getvideo)

    for video in (videos):

        if opts.query:
            if not video:
                raise Exception("No video file detected or specified.")
            else:
                v = Vid(video)
                videoinformation = v.v['filename'], v.gethumansize()
                if fulllist.alist().query(video):
                    print(("A list: " + str(videoinformation)))
                    if opts.notify:
                        notify = notify2.Notification(
                            "VidManager - Video on Alist",
                            str(videoinformation).replace(
                                "/media/1/share/Video", ""),
                            os.path.dirname(
                                os.path.realpath(__file__)) +
                            "/vidmanage.png")
                        notify.show()
                if fulllist.klist().query(video):
                    print(("K list: " + str(videoinformation)))
                    if opts.notify:
                        notify = notify2.Notification(
                            "VidManager - Video on Klist",
                            str(videoinformation).replace(
                                "/media/1/share/Video", ""),
                            os.path.dirname(
                                os.path.realpath(__file__)) +
                            "/vidmanage.png")
                        notify.show()
                if fulllist.dlist().query(video):
                    print(("D list: " + str(videoinformation)))
                    if opts.notify:
                        notify = notify2.Notification(
                            "VidManager - Video on Dlist",
                            str(videoinformation).replace(
                                "/media/1/share/Video", ""),
                            os.path.dirname(
                                os.path.realpath(__file__)) +
                            "/vidmanage.png")
                        notify.show()
        elif opts.alist:
            if not video:
                raise Exception("No video file detected or specified.")
            if opts.remove:
                fulllist.alist().remove(video)
            else:
                v = Vid(video)
                videoinformation = v.getname(), v.gethumansize()
                if opts.notify:
                    notify = notify2.Notification(
                        "VidManager - Appending to Alist",
                        str(videoinformation).replace(
                            "/media/1/share/Video", ""),
                        os.path.dirname(
                            os.path.realpath(__file__)) +
                        "/vidmanage.png")
                    notify.show()
                try:
                    fulllist.alist().append(video)
                    fulllist.klist().remove(video)
                    fulllist.dlist().remove(video)
                except:
                    pass
        elif opts.klist:
            if not video:
                raise Exception("No video file detected or specified.")
            if opts.remove:
                fulllist.klist().remove(video)
            else:
                v = Vid(video)
                videoinformation = v.getname(), v.gethumansize()
                if opts.notify:
                    notify = notify2.Notification(
                        "VidManager - Appending to Klist",
                        str(videoinformation).replace(
                            "/media/1/share/Video", ""),
                        os.path.dirname(
                            os.path.realpath(__file__)) +
                        "/vidmanage.png")
                    notify.show()
                try:
                    fulllist.klist().append(video)
                    fulllist.alist().remove(video)
                    fulllist.dlist().remove(video)
                except:
                    pass
        elif opts.dlist:
            if not video:
                raise Exception("No video file detected or specified.")
            if opts.remove:
                fulllist.dlist().remove(video)
            else:
                v = Vid(video)
                videoinformation = v.getname(), v.gethumansize()
                if opts.notify:
                    notify = notify2.Notification(
                        "VidManager - Appending to Delete List",
                        str(videoinformation).replace(
                            "/media/1/share/Video", ""),
                        os.path.dirname(
                            os.path.realpath(__file__)) +
                        "/vidmanage.png")
                    notify.show()
                fulllist.dlist().append(video)
                fulllist.alist().remove(video)
                fulllist.klist().remove(video)
        elif opts.remove:
            if not video:
                raise Exception("No video file detected or specified.")
            v = Vid(video)
            videoinformation = v.getname(), v.gethumansize()
            if opts.notify:
                notify = notify2.Notification(
                    "VidManager - Removing from lists",
                    str(videoinformation).replace(
                        "/media/1/share/Video", ""),
                    os.path.dirname(
                        os.path.realpath(__file__)) +
                    "/vidmanage.png")
                notify.show()
            fulllist.alist().remove(video)
            fulllist.klist().remove(video)
            fulllist.dlist().remove(video)
        elif opts.info:
            print("A List")
            fulllist.alist().prettyprintlist()
            print("K List")
            fulllist.klist().prettyprintlist()
            print("D List")
            fulllist.dlist().prettyprintlist()
        elif opts.videoinfo:
            if not video:
                raise Exception("No video file detected or specified.")
            v = Vid(video)
            videoinformation = v.getname(), v.gethumansize()
            #       datetime.fromtimestamp(v.getattr()['stat'][-1])
            if opts.notify:
                lists = ""
                for L in ["a", "k", "d"]:
                    for LL in eval("fulllist." + L + "()"):
                        try:
                            if LL.filename == v.getname():
                                lists = lists + "On " + L + " list\n"
                            else:
                                print("Not equal to", L, str(videoinformation))
                        except AttributeError:
                            pass

                notify = notify2.Notification(
                    "VidManager - Information",
                    str(videoinformation) + "\n" + lists,
                    os.path.dirname(
                        os.path.realpath(__file__)) +
                    "/vidmanage.png")
                notify.show()
            else:
                print(str(videoinformation))
        elif opts.output:
            for v in fulllist.alist().getlist():
                try:
                    print(v.getname())
                except:
                    warnings.warn("Bad video somewhere removed")
                    fulllist.alist().remove(video)
        elif opts.outputall:
            for v in fulllist.alist().getlist():
                print(v.getname())
            for v in fulllist.klist().getlist():
                print(v.getname())
        elif opts.purgelist:
            fulllist.dlist().purgelist()

    if not opts.dryrun:
        vidlistfile.save()
