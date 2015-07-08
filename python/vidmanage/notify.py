#!/usr/bin/env python
# encoding: utf-8

import notify2

''' libnotify needs some init value,
it really can be anything, it just uses it
to differentiate between the popups
'''
notify2.init("Basic")

n = notify2.Notification("Title",
                         "Some sample content"
                         )

n.show()
