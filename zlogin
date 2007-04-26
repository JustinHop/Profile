# /etc/zsh/zlogin
# The login startup file for the Z shell.
# Enter only zsh specific commands executed on login, as zsh reads
# /etc/profile on login, like all other Bourne-like shells.
ZLOGIN_VERSION="1.2.4"

#[ -e /etc/D ] && echo "Reading /etc/zsh/zlogin."
#[ -e /etc/D ] && echo "/etc/zsh/zlogin: \$-='$-'" 1>&2

uptime
echo "Welcome $USER, to $HOST on $TTY<$TERM> runnning $OSTYPE"
echo $DISTRO_VER
echo "Running: $0 $ZSH_VERSION"
[[ -n `whence fortune` ]] && echo && fortune && echo

if [[ -z $ORI_XTITLE && \
   ( -x `whence xtitle` || -x /usr/local/bin/xtitle ) && \
   ( $TERM == *xterm* || $TERM == rxvt ) ]]; then
      export ORI_XTITLE="`xtitle -r 2&> /dev/null`"
fi

if [[ -z $BASETERM ]]; then
   export BASETERM=$TERM
fi

if [[ $DISTRO = "redhat" ]]; then
   DEFMAP=/lib/kbd/keymaps/i386/qwerty/defkeymap.map.gz
   if [[ $TERM = "linux" ]]; then
    if [[ `/sbin/consoletype` = "vt" ]]; then
      if [[ -f $DEFMAP ]]; then
         loadkeys defkeymap
      fi
    fi
   fi
else 
   if [[ $DISTRO = "slackware" ]]; then
      if loadkeys justin &> /dev/null ; then
         print Loading keymap justin.map.gz
      fi
   fi
fi




# vim: ts=8 
