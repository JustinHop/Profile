#!/usr/bin/env python

import os, sys, dbus
from random import randint

program = os.path.basename(sys.argv[0])
from_file = 0
ICON = u'\u21e8 '               		# rightwards white arrow

bus = dbus.SessionBus()
obj = bus.get_object("im.pidgin.purple.PurpleService", "/im/pidgin/purple/PurpleObject")
purple = dbus.Interface(obj, "im.pidgin.purple.PurpleInterface")

def help():
	print """
	"""+ program +""": Used for setting pidgin status message.

	Usage: """+ program +""" [-m|-f] status_message

	-m)	Message is information about current song
	-f)	Message should be read from a file. Random line from the file will be chosen.
	"""
	sys.exit(1)

def get_quote():				# function reads a file and gets random line
	num_lines = 0
	rand_line = 0
	l = 0

	try:
		file = sys.argv[2]		# check if we have the file
	except:
		sys.exit(1)

	if os.path.isfile(file):		# is file really there
		f = open(file, "r")		# open the file
		for line in f:			# go through the file and count the lines
			num_lines += 1
	else:
		sys.exit(1)

	rand_line = randint(0, num_lines)	# get the random line
	f.seek(0)	 			# go to the begining of the file
	for line in f:				# loop on the file till we get to the correct line
		if l == rand_line:		# if line correct
			quote = line.strip()	# get the line content
			break
		else:
			l += 1

	f.close()				# close the file and return the line
	return quote

def pidgin_status(message):
	old_status = purple.PurpleSavedstatusGetCurrent()		# get current status
	status_type = purple.PurpleSavedstatusGetType(old_status)	# get current status type
	new_status = purple.PurpleSavedstatusNew("", status_type)	# create new status with old status type
	purple.PurpleSavedstatusSetMessage(new_status, ICON + message)	# fill new status with status message
	purple.PurpleSavedstatusActivate(new_status)			# activate new status


try:
	if sys.argv[1] == '-m':			# is input song data
		ICON = u'\u266C '		# beamed sixteenth notes
		if sys.argv[2]:			# is song data passed
			msg = ' '.join(sys.argv[2:])
	elif sys.argv[1] == '-f':		# should we read from the file
		msg = get_quote()
	else:					# by default just set the message
		msg = ' '.join(sys.argv[1:])
except:
	help()

pidgin_status(msg)				# set pidgin status message
