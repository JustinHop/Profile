#!/bin/bash

/usr/bin/ionice -c 3 /usr/bin/nice /usr/bin/sabnzbdplus $@
