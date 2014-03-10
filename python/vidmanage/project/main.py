import sys
import pickle
from datetime import datetime
from pprint import pprint

from lib import Vid, VidList, VidListFull, VidDList, VidListFile
from lib import Options
from lib import FindVideo

if __name__ == '__main__':
    options = Options()
    opts = options.parse()

    vidlistfile = VidListFile(opts.listfile)
    fulllist = vidlistfile.load()

    fv = FindVideo()
    video = opts.testfile or fv.getvideo()

    if opts.alist:
        if not video:
            raise Exception("No video file detected or specified.")
        if opts.remove:
            fulllist.alist().remove(video)
        else:
            fulllist.alist().append(video)
    elif opts.dlist:
        if not video:
            raise Exception("No video file detected or specified.")
        if opts.remove:
            fulllist.dlist().remove(video)
        else:
            fulllist.dlist().append(video)
    elif opts.info:
        print "A List"
        fulllist.alist().prettyprintlist()
        print "D List"
        fulllist.dlist().prettyprintlist()
    elif opts.videoinfo:
        if not video:
            raise Exception("No video file detected or specified.")
        v = Vid(video)
        print v.getname(), v.gethumansize(), \
            datetime.fromtimestamp(v.getattr()['stat'][-1])
    elif opts.output:
        for v in fulllist.alist().getlist():
            print v.getname(),
    elif opts.purgelist:
        fulllist.dlist().purgelist()

    if not opts.dryrun:
        vidlistfile.save()
