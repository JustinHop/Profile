#!/bin/zsh

cat ~/.xsession-errors > ~/.xsession-errors-1
echo > ~/.xsession-errors

date
echo "New Session on $HOSTNAME" | figlet -w 1000

if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    ## if not found, launch a new one
    eval `dbus-launch --sh-syntax --exit-with-session`
    echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi



#ssh-agent dbus-launch awesome & 
#WMPID=$!

#if xrandr | grep DVI-D_1 ; then
#	xrandr --output PANEL --off
#	xrandr --output DVI-D_1 --auto
#	xrandr --output VGA_1 --auto --right-of DVI-D_1
#else
#	xrandr --output PANEL --auto
#	if xrandr | grep VGA_1 ; then
#	    xrandr --output VGA_1 --auto --right-of PANEL
#	fi
#fi

#if xrandr -q | grep -P '\sconnected' | grep DFP1 ; then
#	xrandr --output LCD --off 
#	xrandr --output CRT1 --auto 
#	xrandr --output DFP1 --auto  --left-of CRT1 
#else
#	if xrandr -q | grep -P '\sconnected' | grep CRT1 ; then
#	    xrandr --output CRT1 --auto --right-of LCD
#	fi
#fi

#xrandr --output CRT1 --right-of DFP1 --rotate left --auto || true

conky --config ~/Profile/conky-${HOST}.conf &

echo "Session: setting Xdefaults and Xmodmap"
[ -e ~/.Xdefaults ] && xrdb -merge ~/.Xdefaults
[ -e ~/.Xmodmap ] && xmodmap ~/.Xmodmap > /dev/null 2>&1
[ -e ~/.xmodmap ] && xmodmap ~/.xmodmap > /dev/null 2>&1

echo "Session: Setting Keyboard Repeat Rate 350ms delay 50hz repeat"
xset r rate 350 50

setxkbmap -option terminate:ctrl_alt_bksp

runonce mpd &
runonce mpdas &
runonce mpn.py &

if [[ $HOST = tux2 ]]; then
    runonce xcompmgr -fF -I-.002 -O-.003 -D1 -cC -t-5 -l-6 -r5
fi

xbindkeys || true
parcellite &
numlockx  &
{ sleep 10s; ~/bin/synergy ; } &
autocutsel -d -s PRIMARY &
autocutsel -d -s CLIPBOARD &
wicd-client &

xscreensaver-command -exit > /dev/null || true
xscreensaver -no-splash &

{ while true; do 
    sleep 10s;
    xmodmap -e 'remove Lock = Caps_Lock' >& /dev/null;
    xmodmap -e 'keysym Caps_Lock = Control_L' >& /dev/null;
    xmodmap -e 'add Control = Control_L' >& /dev/null;
done > /dev/null ; } &

gnome-power-manager &
gnome-settings-daemon &
padevchooser &
#nm-applet --sm-disable &             
update-notifier || true &

uname -a

{ sleep 5s; nitrogen --restore; } &
{ sleep 9s; nitrogen --restore; } &

exec bash -c 'while true ; do awesome ; done;'
