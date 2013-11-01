#!/bin/bash
#===============================================================================
#
#          FILE:  session_ender.sh
# 
#         USAGE:  ./session_ender.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#       COMPANY:  Live Nation
#       VERSION:  1.0
#       CREATED:  06/20/2013 01:48:41 PM PDT
#      REVISION:  ---
#===============================================================================


#!/bin/sh

ACTION=`zenity --width=200 --height=250 --list --radiolist --text="Select logout action" --title="Logout" --column "Choice" --column "Action" TRUE Killall FALSE Shutdown FALSE Reboot FALSE LockScreen FALSE Suspend`

if [ -n "${ACTION}" ];then
  case $ACTION in
  Killall)
    nohup killall -9 -u justin &
    ;;
  Shutdown)
    #zenity --question --text "Are you sure you want to halt?" && gksudo halt
    ## or via ConsoleKit
    dbus-send --system --dest=org.freedesktop.ConsoleKit.Manager \
    /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop
    ;;
  Reboot)
    #zenity --question --text "Are you sure you want to reboot?" && gksudo reboot
    ## Or via ConsoleKit
    dbus-send --system --dest=org.freedesktop.ConsoleKit.Manager \
    /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart
    ;;
  Suspend)
    #gksudo pm-suspend
    dbus-send --system --print-reply --dest=org.freedesktop.Hal \
    /org/freedesktop/Hal/devices/computer \
    org.freedesktop.Hal.Device.SystemPowerManagement.Suspend int32:0
    # HAL is deprecated in newer systems in favor of UPower etc.
    # dbus-send --system --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend
    ;;
  LockScreen)
    #slock
    gnome-screensaver-command -l
    ;;
  esac
fi
