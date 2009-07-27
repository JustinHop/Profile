# /etc/zsh/zlogout
# Sourced upon logging out from a Z shell login.
if [[ -z $ZLOGOUT_VERSION ]]; then
    ZLOGOUT_VERSION=1.0.0
#[ -e /etc/D ] && echo "Reading /etc/zsh/zlogout."

# Clear tty if logged on the console.
    [[ -n "$TTY" && "$TTY" == /dev/tty<1-8> ]] && clear
    echo "The ZSH is over."
    uptime
fi
# vim: ts=8
