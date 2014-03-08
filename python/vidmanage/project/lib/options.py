import sys
from argparse import ArgumentParser


class Options:

    def __init__(self):
        self._init_parser()

    def _init_parser(self):
        prog = sys.argv[0]
        self.parser = ArgumentParser(prog)
        self.group = self.parser.add_mutually_exclusive_group()
        self.group.add_argument('-a', '--alist', dest='addtoalist',
                                metavar='videofile',
                                help="Add curent \
                                playing video to Alist")
        self.group.add_argument('-d', '--delete', dest='addtormlist',
                                metavar='videofile',
                                help="Add current \
                                playing video to remove list")
        self.group.add_argument('-i', '--info', dest='info',
                                action='store_true',
                                help="Print information about current \
                                delete list")
        self.parser.add_argument('-n', '--dryrun', dest='dryrun',
                                 action='store_true',
                                 help="Dryrun, take no real file actions")
        self.group.add_argument('-p', '--purge', dest='purgelist',
                                action='store_true',
                                help='Delete all videos on remove list')

    def parse(self, args=None):
        return self.parser.parse_args(args)
