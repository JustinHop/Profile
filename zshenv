#  $Id$
#  Justin Hoppensteadt <zshy-goodness@justinhoppensteadt.com>
#  http://justinhoppensteadt.com/svn/profile/zshenv
#  Both kinds of free

export __ZSHENV__=0.2.4a

export HOSTNAME=`hostname`
export UNAME=`uname`

export PROFILE_DIR=$HOME/Profile

#export SHELL=$(which $0)
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
PROFILE_DIR=~/Profile
COMMON_PATH="$HOME/bin:$HOME/Profile/bin:$PATH:/usr/bin/wrappers:/bin:/usr/bin:/usr/local/bin"
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
USER_PATH="$HOME/bin:$HOME/profile/bin:/usr/lib/xscreensaver"
ENCODE_PATH="/usr/local/enctools/bin"
NAGIOS_PATH="/usr/local/nagios/libexec"
LOCAL_PERL5_PATH="$HOME/perl5/bin"
LOCAL_PYTHON_PATH="$HOME/.local/bin"

typeset -U PATH
typeset -U LD_LIBRARY_PATH
typeset -U LD_EXEC_PATH
typeset -U PKG_CONFIG_PATH

PATH=$LOCAL_PYTHON_PATH:$LOCAL_PERL5_PATH:$ENCODE_PATH:$COMMON_PATH:$ROOT_PATH:$SVN_PATH:$MYSQL_PATH:$POSTFIX:$PHP_PATH
PATH=$PATH:$APACHE_PATH:$LAMEPATH:$FFMPEGPATH:$USER_PATH:$NAGIOS_PATH

[ -d $DISTCC_PATH ] && PATH="$DISTCC_PATH:$PATH"

if [[ -z "$DONT_TOUCH_LD" ]]; then
    LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib:/$HOME/lib"
    if [[ `uname -p` == "x86_64" ]]; then
        LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib64:/usr/lib64:/usr/local/lib64:/$HOME/lib64
    fi
fi

fpath=( $fpath "$PROFILE_DIR/functions" "~/zsh/functions" "~/.zsh/functions" "$HOME/Profile/zsh" )

for MMAN in "/usr/local/{openldap,svn,netperf,mysql,snort}/man" ; do
if [[ -d $MMAN ]]; then
    export MANPATH=$MMAN:$MANPATH
fi
done

#
# PICKY SETTINGS
#

export SURFRAW_text_browser=elinks
export SURFRAW_graphical=no

alias J="ssh -A jhoppensteadt@justin2.sys.dev99.websys.tmcs"
alias JR="ssh -A root@justin2.sys.dev99.websys.tmcs"
alias B="ssh -A jhoppensteadt@bld1.sys.tools1.websys.tmcs"
alias BR="ssh -A bld1.sys.tools1.websys.tmcs"

alias IE="wine 'C:\Program Files\Internet Explorer\iexplore'"

export FTP_PASSIVE=1
export MINICOM="-c on -m"
export LESS="-isaFMXRU"
export MANLESS="-isaFMXR"
alias man='LESS=$MANLESS man'
export VISUAL=vim
export SVN_EDITOR=vim
export EDITOR=vim
export MYSQL_PS1="mysql (\U@\h)::(\d) \c > "
export FIREFOX_DSP="padsp"
export NSS_DEFAULT_DB_TYPE=sql

export DEBEMAIL=Justin.Hoppensteadt@umgtemp.com
export DEBFULLNAME="Justin Hoppensteadt"

[ -n `whence less` ] && PAGER=less || PAGER=more
export PAGER

if [[ "$TERM" == "screen" ]]; then
    alias htop="TERM=xterm htop"
fi

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
spec="$HOME/build/SPECS"
pf="$HOME/Profile"

if [[ -d /usr/local/apache2 ]]; then
	www=/usr/local/apache2
	wwwc=/usr/local/apache2/conf
	wwwb=/usr/local/apache2/bin
fi

export DEBEMAIL="debian@justinhoppensteadt.com"
export DEBFULLNAME="Justin Hoppensteadt"

PATH=${PATH:s/::/:/}
PERL_CPANM_OPT="--local-lib=~/perl5"

if [ -d ~/perl5/lib/perl5 ]; then
    if [ -z "$PERL5LIB" ]; then
        export PERL5LIB=~/perl5/lib/perl5
    else
        export PERL5LIB=~/perl5/lib/perl5:$PERLLIB
    fi
fi

if [ -f $PROFILE_DIR/zshenv.local ]; then
	. $PROFILE_DIR/zshenv.local
fi

export PATH=$HOME/bin:/usr/bin:$PATH

# vim:ft=zsh:syn=zsh
