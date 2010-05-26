#!/bin/zsh

cat ~/.xsession-errors > ~/.xsession-errors-1
echo > ~/.xsession-errors


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

conky --config ~/Profile/conky-tux2.conf &

date
echo "New Session on $HOSTNAME" | figlet -w 1000

echo "Session: setting Xdefaults and Xmodmap"
[ -e ~/.Xdefaults ] && xrdb -merge ~/.Xdefaults
[ -e ~/.Xmodmap ] && xmodmap ~/.Xmodmap > /dev/null 2>&1

echo "Session: Setting Keyboard Repeat Rate 350ms delay 50hz repeat"
xset r rate 350 50

echo "Session: Setting xrandr"
#jrandr

setxkbmap -option terminate:ctrl_alt_bksp

xbindkeys || true
klipper || true
numlockx &
{ sleep 10s; ~/bin/synergy ; } &
autocutsel -d -s PRIMARY &
wicd-client &



#autoautossh &

xscreensaver-command -exit > /dev/null || true
xscreensaver -no-splash &

{ while true; do 
    sleep 10s;
    xmodmap -e 'remove Lock = Caps_Lock' >& /dev/null;
    xmodmap -e 'keysym Caps_Lock = Control_L' >& /dev/null;
    xmodmap -e 'add Control = Control_L' >& /dev/null;
done > /dev/null ; } &


gnome-settings-daemon &
gnome-power-manager &
#padevchooser &
#nm-applet --sm-disable &             
update-notifier &

uname -a

{ sleep 5s; nitrogen --restore; } &
{ sleep 9s; nitrogen --restore; } &

exec ssh-agent dbus-launch bash -c 'while true ; do awesome ; done;' 

