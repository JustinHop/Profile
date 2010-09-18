#!/bin/zsh

cat ~/.xsession-errors > ~/.xsession-errors-1
echo > ~/.xsession-errors

conky --config ~/Profile/conky-$HOST.conf &

date
echo "New Session on $HOSTNAME" | figlet -w 1000

if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    ## if not found, launch a new one
    eval `dbus-launch --sh-syntax --exit-with-session`
    echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi

echo "Session: setting Xdefaults and Xmodmap"
[ -e ~/.Xdefaults ] && xrdb -merge ~/.Xdefaults
[ -e ~/.Xmodmap ] && xmodmap ~/.Xmodmap > /dev/null 2>&1

echo "Session: Setting Keyboard Repeat Rate 350ms delay 50hz repeat"
xset r rate 350 50

setxkbmap -option terminate:ctrl_alt_bksp

runonce mpd &
runonce mpdas &
runonce mpn.py &

if whence davmail >& /dev/null ; then
    runonce davmail &
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
done ; } &

gnome-power-manager &
gnome-settings-daemon &
padevchooser &
update-notifier || true &

uname -a

{ sleep 5s; nitrogen --restore; } &
{ sleep 9s; nitrogen --restore; } &
{ sleep 1m; pidgin; } &
{ sleep 1m; pidgin_fortune; } &


exec ssh-agent bash -c 'while true ; do awesome ; done;'
