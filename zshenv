################################################################################
#   zshenv
#   justin hoppensteadt
#   http://root-squash.ath.cx/
#
#   c 2007-04-11
#   v 0.1
#
################################################################################


################################################################################
#   host based vars
export HOSTNAME=`hostname`
export UNAME=`uname`

################################################################################
#   user based vars
if [[ -x `whence whoami` ]]; then
    USER=`whoami`
elif [[ -x `whence id` ]]; then
    USER=`id | cut -d'(' -f2 | cut -d')' -f1`
fi

if [[ -n $USER ]]; then
    export LOGNAME=$USER
    export HOME="`echo ~$USER`"
    USERNAME=$LOGNAME
fi

SHORTUSER="$USERNAME"
case $USER in
    root)
        SHORTUSER="/"
    ;;
    remote_ssh)
        SHORTUSER="REM"
    ;;
    justin)
        SHORTUSER="J"
    ;;
    jhoppens)
        SHORTUSER="JH"
    ;;
    jhoppensteadt)
        SHORTUSER="JHop"
    ;;
esac
export SHORTUSER

################################################################################
#   home
for PRODIR in "~" "~/profile" "/etc" "/etc/profile" "~/.profile" ; do
    if [ -z "$PROFILE_DIR" ]; then
        if [[  -f "$PRODIR/profile_dir"  ||  -f "$PRODIR/.profile_dir"  ]]; then
            export PROFILE_DIR="$PRODIR"
            export ZTCDIR="$PROFILE_DIR"
            PATH="$PATH:$ZTCDIR/bin"
        fi
   fi 
done

if [[ -f "$PROFILE_DIR/include" ]]; then
    . "$PROFILE_DIR/include" || echo "Include has errors"
fi

################################################################################
#   path
COMMON_PATH="$HOME/bin:$PATH:/usr/bin/wrappers:/bin:/usr/bin:/usr/local/bin"
ROOT_PATH="/sbin:/usr/sbin:/usr/local/sbin"
UNIXWARE_PATH="/usr/dt/bin:/usr/ucb:/usr/X/bin:/opt/vxvm-va/bin"
LIN_PATH="/usr/X11R6/bin:/usr/X11/bin"
SCO_PATH="/usr/gnu/bin:/usr/gnu/obin:/usr/gnu/sbin:/etc:/usr/bin/X11"
JAVA_PATH="/usr/java/bin"
KDE_PATH="/usr/kde/3.*/bin"
SUN_PATH="/usr/ccs/bin:/opt/SUNWspro/bin"

typeset -U PATH
typeset -U LD_LIBRARY_PATH
typeset -U LD_EXEC_PATH
typeset -U PKG_CONFIG_PATH

PATH=$COMMON_PATH:$ROOT_PATH

[ -d $DISTCC_PATH ] && PATH="$DISTCC_PATH:$PATH"

if [[ -z ${LD_LIBRARY_PATH} ]]; then
   LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"
fi

fpath=( $fpath "$PROFILE_DIR/functions" "~/zsh/functions" "~/.zsh/functions" )

if [[ -z $JAVA_HOME ]]; then
    for i in /usr/java /usr/java/j2re1.4.2_06 /usr/lib/java/bin \
        /opt/NetBeans3.6/ /opt/NetBeans3.6a/ /opt/blackdown-jdk-1.4.1/ \
        /opt/blackdown-jre-1.4.1/ /opt/netbeans-3.5.1/  /opt/sun-jdk-1.4.2.06/ \
        /usr/java/j2re1.4.2_01/ ; do
        if [[ -d $i ]]; then JAVA_HOME=${i} ; fi
    done
fi

export JAVA_HOME
# Re-arranged per Red Hat's recomendations
# and fixed by me many... many times. fuck java
export PATH=$JAVA_HOME:$JAVA_HOME/bin:$PATH

################################################################################
#   session
export FTP_PASSIVE=1
export MINICOM="-c on -m"
export LESS="-isaFMXR"
export VISUAL=vi
export EDITOR=vi

[ -n `whence less` ] && PAGER=less || PAGER=more
export PAGER
 
DIRSTACKSIZE=20
LISTMAX=1000
REPORTTIME=10
if [[ -z $ORI_XTITLE ]]; then
    export ORI_XTITLE="${USERNAME}@${HOSTNAME}:${UNAME}"
fi

################################################################################
#   shortcuts
lsrc="/usr/local/src"
dzsh="/etc/zsh"



# vim:ft=zsh:syn=zsh:tw=4
