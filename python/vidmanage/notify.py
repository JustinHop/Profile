#!/usr/bin/env python
# encoding: utf-8

import pynotify

''' libnotify needs some init value,
it really can be anything, it just uses it
to differentiate between the popups
'''
pynotify.init("Basic")

n = pynotify.Notification("Title",
  "Some sample content"
)

n.show()
