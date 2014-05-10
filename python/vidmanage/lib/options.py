import sys
from argparse import ArgumentParser
from os.path import expanduser


class Options:

    def __init__(self):
        self._init_parser()

    def _init_parser(self):
        self.parser = ArgumentParser(prog=sys.argv[0])
        self.group = self.parser.add_mutually_exclusive_group()
        self.group.add_argument('-a', '--alist', dest='alist',
                                action='store_true',
                                help="Add curent \
                                playing video to Alist")
        self.group.add_argument('-k', '--keep', dest='klist',
                                action='store_true',
                                help="Add curent \
                                playing video to keep list")
        self.group.add_argument('-d', '--delete', dest='dlist',
                                action='store_true',
                                help="Add current \
                                playing video to remove list")
        self.group.add_argument('-i', '--info', dest='info',
                                action='store_true',
                                help="Print information about current \
                                lists")
        self.group.add_argument('-I', '--videoinfo', dest='videoinfo',
                                action='store_true',
                                help="Print information about current \
                                video being watched, if any")
        self.group.add_argument('-O', '--outputall', dest='outputall',
                                action='store_true',
                                help="Output current alist and klist")
        self.group.add_argument('-o', '--output', dest='output',
                                action='store_true',
                                help="Output current alist")
        self.group.add_argument('-p', '--purge', dest='purgelist',
                                action='store_true',
                                help='Delete all videos on remove list')
        self.parser.add_argument('-r', '--remove', dest='remove',
                                 action='store_true',
                                 help='Remove current file from requested \
                                 list')
        self.parser.add_argument('-n', '--dryrun', dest='dryrun',
                                 action='store_true',
                                 help="Dryrun, take no real file actions")
        self.parser.add_argument('-f', '--file', dest='listfile',
                                 default=expanduser("~/.vidlist"),
                                 help='Location of list')
        self.parser.add_argument('-t', '--testfile', dest='testfile',
                                 help='Store or remove specified string')

    def parse(self, args=sys.argv[1:]):
        return self.parser.parse_args(args)
