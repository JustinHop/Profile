import os
import os.path


class FindVideo:

    def __init__(self):
        pass

    def getvideo(self):
        vidfile = os.path.expanduser('~') + "/tmp/mpv.last"
        fh = open(vidfile)
        vid = fh.readline().rstrip()
        return(vid)
