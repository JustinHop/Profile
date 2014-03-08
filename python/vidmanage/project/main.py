import sys

from lib import VidManage
from lib import Options

if __name__ == '__main__':
    options = Options()
    opts = options.parse(sys.argv[1:])

    v = VidManage(opts)

    v.date()
    v.print_example_arg()
