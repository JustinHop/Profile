# /etc/zsh/zlogin
# The login startup file for the Z shell.
# Enter only zsh specific commands executed on login, as zsh reads
# /etc/profile on login, like all other Bourne-like shells.
if [[ -z $ZLOGIN_VERSION ]]; then
    ZLOGIN_VERSION="1.2.5"

    uptime
    echo "Welcome $USER, to $HOST on $TTY<$TERM> runnning $OSTYPE on $CPUTYPE"
    echo $DISTRO_VER $0 $ZSH_VERSION

    [[ -n `whence fortune` ]] && echo && fortune && echo

    if [[ -z $ORI_XTITLE && \
       ( -x `whence xtitle` || -x /usr/local/bin/xtitle ) && \
       ( $TERM == *xterm* || $TERM == rxvt ) ]]; then
          export ORI_XTITLE="`xtitle -r 2&> /dev/null`"
    fi

    if [[ -z $BASETERM ]]; then
       export BASETERM=$TERM
    fi

fi
