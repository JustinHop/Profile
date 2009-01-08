#  $Id$
#  Justin Hoppensteadt <zshy-goodness@justinhoppensteadt.com>
#  http://justinhoppensteadt.com/svn/profile/zshenv
#  Both kinds of free

export __ZSHENV__=0.2

if [[ -n "$__INCLUDE__" ]]; then
    [ -e ~/.include ] && source ~/.include
fi

export HOSTNAME=`hostname`
export UNAME=`uname`

#
# WHO AM I
#

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
    hoppenj)
        SHORTUSER="H,J"
    ;;
    jhoppensteadt)
        SHORTUSER="JHop"
    ;;
esac
export SHORTUSER

export SHORTHOST=`echo $HOSTNAME | sed -e 's/.buzznet.com//' -e 's/justinhoppensteadt.com/.jh/'`

#
# PATH
#

COMMON_PATH="$HOME/bin:$PATH:/usr/bin/wrappers:/bin:/usr/bin:/usr/local/bin"
ROOT_PATH="/sbin:/usr/sbin:/usr/local/sbin"
UNIXWARE_PATH="/usr/dt/bin:/usr/ucb:/usr/X/bin:/opt/vxvm-va/bin"
LIN_PATH="/usr/X11R6/bin:/usr/X11/bin"
SCO_PATH="/usr/gnu/bin:/usr/gnu/obin:/usr/gnu/sbin:/etc:/usr/bin/X11"
JAVA_PATH="/usr/java/bin"
KDE_PATH="/usr/kde/3.*/bin"
SVN_PATH="/usr/local/svn/bin"
MYSQL_PATH="/usr/local/mysql/bin"
POSTFIX="/usr/local/postfix/bin:/usr/local/postfix/sbin"
PHP_PATH="/usr/local/websites/php/bin"
APACHE_PATH="/usr/local/websites/apache/bin"
SVN_PATH="/usr/local/svn/bin"
LAMEPATH="/usr/local/websites/lame/bin"
FFMPEGPATH="/usr/local/websites/ffmpeg/bin"
SUN_PATH="/usr/ccs/bin:/opt/SUNWspro/bin"
USER_PATH="$HOME/bin:$HOME/profile/bin"
ENCODE_PATH="/usr/local/enctools/bin"

typeset -U PATH
typeset -U LD_LIBRARY_PATH
typeset -U LD_EXEC_PATH
typeset -U PKG_CONFIG_PATH

PATH=$ENCODE_PATH:$COMMON_PATH:$ROOT_PATH:$SVN_PATH:$MYSQL_PATH:$POSTFIX:$PHP_PATH:$APACHE_PATH:$LAMEPATH:$FFMPEGPATH:$USER_PATH

[ -d $DISTCC_PATH ] && PATH="$DISTCC_PATH:$PATH"

if [[ -z ${LD_LIBRARY_PATH} ]]; then
   LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"
fi

fpath=( $fpath "$PROFILE_DIR/functions" "~/zsh/functions" "~/.zsh/functions" )

for MMAN in "/usr/local/{openldap,svn,netperf,mysql,snort}/man" ; do
if [[ -d $MMAN ]]; then
    export MANPATH=$MMAN:$MANPATH
fi
done

#
# PICKY SETTINGS
#

export FTP_PASSIVE=1
export MINICOM="-c on -m"
export LESS="-isaFMXR"
export VISUAL=vim
export SVN_EDITOR=vim
export EDITOR=vim
export MYSQL_PS1="mysql (\u@$HOST)::\d > "

[ -n `whence less` ] && PAGER=less || PAGER=more
export PAGER
 
DIRSTACKSIZE=20
LISTMAX=1000
REPORTTIME=10
if [[ -z $ORI_XTITLE ]]; then
    export ORI_XTITLE="${USERNAME}@${HOSTNAME}:${UNAME}"
fi

#
# SHORTCUTS
#
lsrc="/usr/local/src"
dzsh="/etc/zsh"
tocf="/home/justin/dev/cfengine/trunk/masterfiles/system/"
cfetc="/home/justin/dev/cfengine/trunk/masterfiles/system/etc"
cfin="/home/justin/dev/cfengine/trunk/masterfiles/system/inputs"
Slap="/usr/local/openldap/etc/openldap/"
amg="/autofs/isilon1/bnmedia1/amg"
bnwww="/usr/local/websites/apache/"
www="/usr/local/websites/apache/"
spec="/home/justin/rpmbuild/SPECS"

# vim:ft=zsh:syn=zsh
