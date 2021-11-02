#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''program skeleton with logging, config file, cli parsing
Usage: program [options]

Options:
    -n                  Dryrun. Do not apply changes.
    -L LEVEL            Logging output level [default: WARNING]
'''

import yaml
import json
import re
import sys
import os
short = os.path.basename(__file__)

import requests

from pprint import pprint, pformat
from docopt import docopt
args = docopt(__doc__)

from pathlib import Path

import logging
loglevel = logging.WARNING

if re.match(r'debug', args['--loglevel'], re.IGNORECASE):
    loglevel = logging.DEBUG
elif re.match(r'warn', args['--loglevel'], re.IGNORECASE):
    loglevel = logging.WARNING
elif re.match(r'info', args['--loglevel'], re.IGNORECASE):
    loglevel = logging.INFO
elif re.match(r'error', args['--loglevel'], re.IGNORECASE):
    loglevel = logging.ERROR

logging.basicConfig(
    level=loglevel,
    format='%(asctime)s - %(levelname)s - %(funcName)s - %(message)s')

configdir = os.path.join(Path.home(), ".config", short)
configfile = os.path.join(configdir, "config.yaml")

try:
    if args['--config'] and os.path.isfile(args['--config']):
        configfile = args['--config']
        configdir = os.path.dirname(configfile)
except TypeError:
    pass

if not os.path.isdir(configdir):
    os.makedirs(configdir)

config = -1
if not os.path.isfile(configfile):
    logging.error("No config file, fool")
    sys.exit(1)
else:
    with open(configfile, "r") as c:
        config = yaml.load(c, Loader=yaml.SafeLoader)
        config = config[short]

try:
    basestring
except NameError:  # python3
    basestring = str

def main():
    logging.debug(args)
    logging.debug(config)

if __name__ == "__main__":
    main()
