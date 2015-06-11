import sys
from argparse import ArgumentParser
from os.path import expanduser


class Options:

    def __init__(self):
        self._init_parser()

    def _init_parser(self):
        self.parser = ArgumentParser(prog=sys.argv[0])
        self.group = self.parser.add_argument_group(
            'list',
            'List I/O operations')
        self.groupd = self.parser.add_argument_group(
            'display',
            'Commands for displaying video lists')
        self.group.add_argument('-q', '--query', dest='query',
                                action='store_true',
                                help="Query curent \
                                video in lists")
        self.group.add_argument('-a', '--alist', dest='alist',
                                action='store_true',
                                help="Add video to Alist")
        self.group.add_argument('-k', '--keep', dest='klist',
                                action='store_true',
                                help="Add video to keep list")
        self.group.add_argument('-d', '--delete', dest='dlist',
                                action='store_true',
                                help="Add video to remove list")
        self.groupd.add_argument('-i', '--info', dest='info',
                                 action='store_true',
                                 help="Print information about lists")
        self.groupd.add_argument('-I', '--videoinfo', dest='videoinfo',
                                 action='store_true',
                                 help="Print information about video")
        self.groupd.add_argument('-O', '--outputall', dest='outputall',
                                 action='store_true',
                                 help="Output current alist and klist")
        self.groupd.add_argument('-o', '--output', dest='output',
                                 action='store_true',
                                 help="Output current alist")
        self.group.add_argument('-p', '--purge', dest='purgelist',
                                action='store_true',
                                help='Delete all videos on remove list')
        self.group.add_argument('-r', '--remove', dest='remove',
                                action='store_true',
                                help='Remove current file from all \
                                 lists')
        self.parser.add_argument('-n', '--dryrun', dest='dryrun',
                                 action='store_true',
                                 help="Dryrun, take no real file actions")
        self.parser.add_argument('-N', '--notify', dest='notify',
                                 action='store_true',
                                 help="Use libnotify notifications.")
        self.parser.add_argument('-L', '--list-file', dest='listfile',
                                 default=expanduser("~/.vidlist"),
                                 help='Location of list')
        self.parser.add_argument('FILE', nargs='?',
                                 help='Specify video files manually')

    def parse(self, args=sys.argv[1:]):
        return self.parser.parse_args(args)
