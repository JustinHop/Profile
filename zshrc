#  Justin Hoppensteadt <zshy-goodness@justinhoppensteadt.com>
#  Both kinds of free
#
if [ -z "$VIRTUAL_ENV" ] && [ -f "$PWD"/bin/activate ]; then
  source "$PWD"/bin/activate
fi

for _ZSH_ADDON in \
  Profile/zsh/syntax-highlighting/zsh-syntax-highlighting.plugin.zsh \
  Profile/zsh/zshrc-oh-my-zsh
do
  if [ -f "$HOME/$_ZSH_ADDON" ]; then
    source "$HOME/$_ZSH_ADDON"
  fi
done
unset _ZSH_ADDON

export ZSHRC_VERSION="2.2.1"
export PROFILE_DIR="$HOME/Profile"
export ZSH_MAJOR=$(echo $ZSH_VERSION | cut -d. -f1)
export ZSH_MINOR=$(echo $ZSH_VERSION | cut -d. -f2)
export ZSH_REL=$(echo $ZSH_VERSION | cut -d. -f3)
umask 002
#
# WORKSPACE AND ENVIRONMENT
#

[ -e "$HOME/.zshenv" ] && source "$HOME/.zshenv"

for SPACE in .undo backup .zsh ; do
  [ ! -d "$HOME/$SPACE"  ] && mkdir "$HOME/$SPACE"
done

if [ -f "$HOME"/agent-$HOSTNAME ]; then
  . "$HOME"/agent-$HOSTNAME
fi

#
# UNAME FUN
#
case $UNAME in
  (SunOS)
    if [[ $ZSH_MAJOR = 3 ]]; then
      typeset BKT
      BKT='<>[]{}'
    else
      typeset -a BKT
      BKT=('<' '>' '<[' ']>' '{' '}')
      export BKT
    fi
    export DISTRO=Solaris
    export DISTRO_VER=`uname -r`
    export GNU_COREUTILS=
    export PATH="$HOME/usr/local/bin:$HOME/bin:$SUN_PATH:$PATH"
    TYCOLOR=yellow

    export LD_LIBRARY_PATH="$TBOX/lib:$LD_LIBRARY_PATH:${SUN_PATH:gs/bin/lib/}"

    # Sun ls. ewww.
    if [[ $GNU_COREUTILS != 1 ]]; then
      alias ls="ls -F "
      alias ll="ls -Fl "
      alias l.="ls -Fd .* "
      alias ll.="ls -Fdl .* "
      alias lsd="ls -Fd *(-/) "
      alias lsd.="ls -Fd .*(-/) "
      alias lsf="ls -F *(-.) "
      alias lsln="ls -F *(#q@) "
      alias lss="ls -Fs "
      alias lsh="ls -Fsh "
      alias sl="ls -Fr "
    fi
    ;;

  (Linux)
    [[ -a /etc/redhat-release ]] && export DISTRO=redhat
    [[ -a /etc/slackware-version ]] && export DISTRO=slackware
    [[ -a /etc/gentoo-release ]] && export DISTRO=gentoo

    if tty | grep pts >& /dev/null ; then
      if whence fgconsole >& /dev/null ; then
        LIN=`tty|tr '/' ' '|awk '{ print $3 }'`
        LIN_SCREEN="`fgconsole 2> /dev/null`:$LIN"
      fi
    fi
    export GNU_COREUTILS=1
    export LD_LIBRARY_PATH
    PATH="$PATH:$LIN_PATH"
    TREEPS="f"
    LS="/bin/ls"
    BKT=( '{' '}' '[' ']' '<' '>' )
    export BKT
    TYCOLOR=blue
    if [[ -n $KBD_RATE ]] && [[ -n `whence kbdrate` ]]; then
      alias k="kbdrate $KBD_RATE"
    fi
    case $DISTRO in
      (redhat)
        DISTRO_VER=`cat /etc/redhat-release`
        TYCOLOR=red
        if [[ -d /dvt ]]; then
          PATH="/dvt/bin/linux:$PATH"
        fi
        alias srpm="rpmbuild --target i686 --rebuild"
        alias rpm="rpm --verbose"

        if [[ $TERM = "linux" ]]; then
          if [[ `/sbin/consoletype` = "vt" ]]; then
            #   unicode_start default8x9
          fi
        fi
        ;;

      (slackware)
        DISTRO_VER=`cat /etc/slackware-version`
        # mmmmm slackware
        ;;

      (gentoo)
        DISTRO_VER=`cat /etc/gentoo-release`
        TYCOLOR=magenta
        alias A="ACCEPT_KEYWORDS=\"~x86\" "
        alias doom3="LD_PRELOAD=/usr/lib/libGL.so.1 doom3"
        alias m1='xmodmap -e "pointer = 1 2 3 6 7 4 5"'
        alias m2='xmodmap -e "pointer = 1 2 3 7 6 4 5"'
        export PATH="$PATH:/usr/games/bin:/usr/lib/wine/bin"
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/win/lib"
        ;;
    esac
    ;;

  (Darwin)
    if [[ -f $PROFILE_DIR/dircolors ]]; then
      export CLICOLOR=`cat $PROFILE_DIR/dircolors`
    fi
    alias ls="ls -F "
    BKT=( ':', ':', '<', '>', '{', '}' )
    TYCOLOR=magenta
    ;;

  (CYGWIN_NT-5.1)
    export DISTRO=cygwin
    export GNU_COREUTILS=1
    typeset -a BKT
    BKT=( '[' ']' '<' '>' '({' '})' )
    export BKT
    TYCOLOR=green
    LS="/bin/ls"
    alias ifconfig=ipconfig
    ;;
esac

export PATH

#
# TERMINAL SETTINGS AND KEYBINDINGS
#
autoload -U bindit3
bindit3


#  some defaults
#  ^U    clear line
#  ^R    hist search
#  cmdG + int, int rev hist line
#  ^G    list expands

#  Mine
#  ^N    repeat search
#  ^P    rev search
#  ^B    History expansion

#  F1 = esc on laptops
noop () { }

zle -N noop
bindkey -M vicmd '\e' noop

bindkey -M viins '^W' accept-and-menu-complete
bindkey '^W' accept-and-menu-complete
bindkey '^N' vi-repeat-find
bindkey '^P' vi-rev-repeat-find
bindkey '^B' expand-history
bindkey '^Xx' push-line
bindkey '^U' undo
bindkey '^R' redo

bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^S' history-incremental-search-forward
#bindkey -M vicmd '/' history-incremental-search-backward
#bindkey -M vicmd '?' history-incremental-search-forward

if (( $ZSH_MAJOR >= 4 )); then
  bindkey '^O' all-matches
fi

#
# ALIAS
#

alias Xterm='xterm +bc -cr red -j +sb -u8 +vb -bd red -bg black -fg green'
alias flux='xinit `which startfluxbox`'

alias VPN='openconnect --dump-http-traffic -c ~/.cisco/certificates/client/private/bothkeys.pem -k ~/.cisco/certificates/client/private/client.key --cafile /etc/ssl/certs/ca-certificates.crt -v --os=win --script-tun --script "ocproxy -D 5000 -L 5053:10.75.32.5:53 -L 5054:10.75.33.5:53 -L 5001:jump.ash.syseng.tmcs:22 -L 5002:cas-na.lyv.livenation.com:993 --dns 10.75.32.5 --dns 10.75.33.5 --domain websys.tmcs" ashasg2.ticketmaster.com'

alias fixperms='sudo find -type d -exec chmod 775 {} \; ; sudo find . -type f -exec chmod 664 {} \;'

alias d=dirs
alias pu=pushd
alias po=popd
alias m=mail
alias j=jobs

alias p=proxychains

#alias b='export BACKUP=-'
#alias B='export BACKUP=+'

if echo $HOST | grep -ve '(tux-ninja|alien)' > /dev/null ; then
  export BACKUP=+
fi

if [[ "$DISTRO" == "cygwin" ]]; then
  alias psa="ps -a $TREEPS"
else
  alias psa="ps -A $TREEPS"
fi

alias psc='ps xawf -eo pid,user,cgroup,args'

# silly
alias kew="echo 'Totally.'"
alias orly="echo yarly"

# oops'
alias ,,=".."
alias ks="ls"
alias xs="cd"
alias it=git

# good idea
alias -g "..."="../.."
alias -g "...."="../../.."
alias -g "....."="../../../.."
alias -g "......"="../../../../.."
alias -g "......."="../../../../../.."
alias -g "........"="../../../../../../.."
alias -g "........."="../../../../../../../.."
alias -g ".........."="../../../../../../../../.."

# syncs
alias sync-d2t='cd ; rsync -avb justin@dallas.525sports.com:/var/www/pictures . ; cd - '
alias sync-t2d='cd ; rsync -avb pictures justin@dallas.525sports.com:/var/www ; cd - '

# fix ssh stuff
if [[ -f $HOME/.ssh/*id ]]; then
  chmod 0600 $HOME/.ssh/{authorized_keys,*id}
fi

#
# GNU LS ALIASES
#

if [[ -x `whence zsh-beta` ]]; then
  alias z=`whence zsh-beta`
else
  alias z=$0
fi

if [[ $GNU_COREUTILS -eq 1 ]]; then

  NOR=" --color=auto --hide-control-chars --classify "

  alias  l="$LS --color=always -C -F "
  alias  l.="$LS $NOR -d .* "
  alias  ll.="$LS $NOR -dl .* "
  alias  lh.="$LS $NOR -dsh .* "
  alias  la="$LS $NOR -A "

  alias  ls="$LS $NOR -B "
  alias  ls.="$LS $NOR -d -B .* "
  alias  lsc="$LS --color=always -C -F -B"
  alias  lsd="$LS $NOR -d *(-/) "
  alias  lsf="$LS $NOR -d *(-.) "
  alias  lsh="$LS $NOR -shB"
  alias  lss="$LS $NOR -s"
  alias  lsln="$LS $NOR -d *(#q@) "

  alias  lsa="$LS $NOR -AB "

  alias  ll="$LS $NOR -lB "
  alias  ll.="$LS $NOR -dlB .*"
  alias  lls="$LS $NOR -lsB"
  alias  llh="$LS $NOR -lshB"
  alias  sl="$LS $NOR -B -r"
else
  alias ls="ls -F "
  alias ll="ls -Fl "
  alias l.="ls -Fd .* "
  alias ll.="ls -Fdl .* "
  alias lsd="ls -Fd *(-/) "
  alias lsd.="ls -Fd .*(-/) "
  alias lsf="ls -F *(-.) "
  alias lsln="ls -F *(#q@) "
  alias lss="ls -Fs "
  alias lsh="ls -Fsh "
  alias sl="ls -Fr "
fi

if [[ -f $HOME/.dircolors ]]; then
  eval $(dircolors $HOME/.dircolors)
fi

unset CDPATH

alias RN="rename '$_=ls $_; s![ #$/]!_!g;'"

# ViM
_VIM=vi
if [[ "$VIM_PROFILES" ]]; then
  export VIM_PROFILES
else
  export VIM_PROFILES=${VIM_PROFILES:-"lib:base"}
fi

if [[ -x `whence vim` ]]; then
  _VIM=`whence vim`
fi

if [[ -x ~/bin/vim ]]; then
  _VIM=~/bin/vim
fi

_VIM="$_VIM -p "

export EDITOR=$_VIM
export VISUAL=$_VIM
alias vim=$_VIM
alias vi=$_VIM$VIM_LINUX_TERM
alias v=$_VIM

unset _VIM

if [[ -x `whence rlwrap` ]]; then
  alias imapfilter='rlwrap imapfilter'
fi

alias z=$0
alias s=sudo

# greppy
if [[ -x `whence egrep` ]]; then
  alias -g G="|egrep"
  alias -g GG="|&egrep"
else
  alias -g G="|grep -e"
  alias -g GG="|&grep -e"
fi

# /dev/nullness
alias -g NUL=" > /dev/null "
alias -g NIL=" 2> /dev/null "
alias -g NULL=" >& /dev/null "

# this finds your "best" text browser
if [[ -n `whence elinks` ]]; then
  alias links="elinks"
  alias lynx="elinks"
else
  if [[ -n `whence links` ]]; then
    alias elinks="links"
    alias lynx="links"
  fi
fi

# might as well start with the gui crap
alias rn="rename '$_=lc $_;s/ /_/g' "
#purdy stuff
if [[ -o interactive ]]; then
  for _COLOR in gcc make diff svn ; do
    whence "color${_COLOR}" >> /dev/null && alias ${_COLOR}="color${_COLOR}"
  done
fi
#
# Work  Stuff
#

if [[ -f $HOME/.id ]]; then
  alias huh="cat $HOME/.id"
fi

#alias mpv="optirun mpv"

#
# My Options
#

#   Changing Directories
setopt \
  auto_cd \
  autopushd \
  cdablevars \
  NO_chasedots \
  NO_chaselinks \
  NO_posix_cd \
  pushd_ignore_dups \

  #   Completion
setopt \
  always_to_end \
  autolist \
  automenu \
  auto_name_dirs \
  auto_param_keys \
  auto_param_slash \
  auto_remove_slash \
  bash_auto_list \
  NO_complete_aliases \
  completeinword \
  glob_complete \
  hash_list_all \
  list_ambiguous \
  NO_list_beep \
  list_types \

  #   Expansion and Globs
setopt \
  NO_case_glob \
  extendedglob \
  glob \
  glob_assign \
  NO_glob_dots \
  magic_equal_subst \
  multibyte \
  NO_nomatch \
  null_glob \
  numeric_glob_sort \
  rematch_pcre


setopt  \
  allexport \
  nobeep \
  NObgnice \
  braceccl \
  correct \
  NO_flowcontrol \
  functionargzero \
  globassign \
  globcomplete \
  nohup \
  longlistjobs \
  multios \
  promptsubst \
  vi \
  zle

# history stuff
setopt   \
  appendhistory \
  banghist \
  extendedhistory \
  histexpiredupsfirst \
  NOhistignorespace \
  histignoredups \
  histfindnodups \
  histreduceblanks \
  histverify \
  histfcntllock \
  incappendhistory \
  NO_sharehistory

# bindings for history
# bindkey "^G" set-local-history

if [ "$ZSH_MAJOR"."$ZSH_MINOR" = "5.1" ]; then
  setopt NOallexport
fi

if (( $ZSH_MAJOR >= 4 )); then
  setopt aliases \
    listpacked \
    promptpercent
fi

if (( $ZSH_MAJOR >= 4 )); then
  setopt listtypes \
    mark_dirs \
    menu_complete \
    rc_expand_param \
    zle \
    NOverbose \
    NOsingle_line_zle \
    NO_complete_aliases
fi

if (( $ZSH_MAJOR >= 5 )); then
  autoload -U compinit && compinit
  autoload -U bashcompinit && bashcompinit
fi

################################################
# The following lines were added by compinstall
################################################
if (( $ZSH_MAJOR >= 4 )); then
  zstyle ':completion:*' auto-description 'specify: %d'
  #zstyle ':completion:*' completer _list _expand _complete _match _correct _approximate
  zstyle ':completion:*' completer _complete _expand  _match _correct _list _approximate
  zstyle ':completion:*' completions 1
  zstyle ':completion:*' format 'zcomp: %d'
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
  zstyle ':completion:*' matcher-list '' 'r:|[._-]=* r:|=*'
  zstyle ':completion:*' max-errors 2
  zstyle ':completion:*' menu select=2
  zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

  if (( $ZSH_MAJOR < 5 )); then
    autoload -U compinit
    compinit -u
  fi
fi
# End of lines added by compinstall

###############################################
### completion goodness from zshwiki.org
##############################################
if (( $ZSH_MAJOR >= 4 )); then
  # use cache
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path ~/.zsh/cache-$HOSTNAME

  # ignore lost&found
  zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found'

  zstyle ':completion:*:*:*:commands' ignored-patterns servertool serialver

  # CLEAR OUT THAT DAMNED CD COMPLETION GARBAGE!!!
  zstyle ':completion:*:*:*:users' ignored-patterns \
    avahi \
    adm bin daemon games gdm halt ident junkbust \
    lp mail mailnull named news nscd colors \
    ntp operator pcap postgres radvd rpc rpcuser rpm \
    shutdown squid sshd sync uucp vcsa xfs backup  bind  \
    dictd  gnats  identd  irc  man  messagebus  postfix \
    proxy  sys  www-data colord bin sys sync games news uucp \
    backup list irc gnats nobody libuuid messagebus usbmux whoopsie \
    kernoops rtkit speech-dispatcher colord avahi hplip saned sshd \
    gdm debian-tor statd ftp mpdscribble dnsmasq festival glances \
    trader avahi-autoipd


  #compdef _ssh envssh
  #compdef '_dispatch ssh' essh

  # no functions for programs i dont have
  zstyle ':completion:*:functions' ignored-patterns '_*'

  ### Mine
  CH(){
    for hostfile in /etc/hosts $PROFILE_DIR/hosts /cygdrive/c/WINDOWS/system32/drivers/etc/hosts ; do
      if [ -f $hostfile ]; then
        etchosts+=( $(sed -r 's/(^(\w|\.)+|^.*#.*)//' < $hostfile) )
        #zstyle ':completion:*' hosts $etchosts;
      fi
    done
    zstyle ':completion:*' hosts $etchosts
  }

  CH

  etchosts+=({core,mail,tux,tux-ninja,net1,net,sup1,sup,www,eh}{,.justinhoppensteadt.com} $HOSTNAME)
  zstyle ':completion:*' hosts $etchosts
  compdef _hosts getip
  compdef _modprobe remod
  compdef _mozilla firefox-3.5
  compdef _gnu_generic ssh-keygen
  compdef _gnu_generic onall
  compdef _gnu_generic nhs
  compdef _gnu_generic cloudlb
  compdef _gnu_generic cloudservers
  compdef _gnu_generic cloud_dns

fi

_essh () {
  local service=ssh
  _ssh "$@"
}
compdef _essh essh

#
# COLOR FUNCTIONS
#
I_WANT_COLORS="yes"
if [[ $ZSH_MAJOR = 3 ]]; then
  if [[ -n $I_WANT_COLORS ]]; then
    black=`echo -n "\033[0;30m"`
    red=`echo -n "\033[0;31m"`
    green=`echo -n "\033[0;32m"`
    brown=`echo -n "\033[0;33m"`
    blue=`echo -n "\033[0;34m"`
    magenta=`echo -n "\033[0;35m"`
    cyan=`echo -n "\033[0;36m"`
    white=`echo -n "\033[0;37m"`
    underline=`echo -n "\033[0;38m"`
    default=`echo -n "\033[0;39m"`
    violet=`echo -n "\033[1;35m"`
  fi
fi

#
# PROMPT MADNESS
#
if (( $ZSH_MAJOR >= 4 )); then
  autoload -U colors
  colors
  autoload salty
fi



if [[ -o interactive ]]; then
  autoload -U promptinit
  autoload throw
  autoload catch
  promptinit
  #  if (( $ZSH_MAJOR == 4 && $ZSH_MINOR >= 3 || $ZSH_MAJOR > 4 )); then
  #    {
  #      prompt clint || throw BADPROMPT
  #    } always {
  #    if catch *; then
  #      echo got here
  #      prompt clint
  #    fi
  #  }
  #  else
  #    prompt clint
  #  fi

  #autoload -U title
  #autoload -U precmd
  #autoload -U preexec
fi

function preexec() {
  local a=${${1## *}[(w)1]}  # get the command
  local b=${a##*\/}   # get the command basename
  a="${b}${1#$a}"     # add back the parameters
  a=${a//\%/\%\%}     # escape print specials
  a=$(print -Pn "$a" | tr -d "\t\n\v\f\r")  # remove fancy whitespace
  a=${(V)a//\%/\%\%}  # escape non-visibles and print specials

  case "$b" in
    envssh|essh|ssh)
      #a=${a#ssh }
      a=${a%%.*}
      a=${a##* }
      ;;
    *)
      a=${a//.websys.tmcs}
      a=${${1## *}[(w)1]}  # get the command
      a=${a##*\/}   # get the command basename
      a=${a[1,10]}
      ;;
  esac


  case "$TERM" in
    screen|screen.*)
      # See screen(1) "TITLES (naming windows)".
      # "\ek" and "\e\" are the delimiters for screen(1) window titles
      #print -Pn "\ek%-3~ $a\e\\" # set screen title.  Fix vim: ".
      #print -Pn "\e]2;%-3~ $a\a" # set xterm title, via screen "Operating System Command"
      print -Pn "\ek$a\e\\" # set screen title.  Fix vim: ".
      print -Pn "\e]2;$a\a" # set xterm title, via screen "Operating System Command"
      ;;
    rxvt|rxvt-unicode|xterm|xterm-color|xterm-256color)
      print -Pn "\e]2;%m:%-3~ $a\a"
      ;;
  esac
}

function precmd() {
  case "$TERM" in
    screen|screen.rxvt)
      print -Pn "\ek%-3~\e\\" # set screen title
      print -Pn "\e]2;%-3~\a" # must (re)set xterm title
      ;;
  esac
}

bindkey -v

case $USER in
  (justin)
    prompt jclint
    ;;
  (root)
    prompt jclint green white red
    ;;
  (*)
    prompt jclint green blue white
    ;;
esac


#
#  postexec
#

# pagers and cutters
alias -g L="|less"
alias -g LL="|&less"
alias -g M="|more"
alias -g MM="|&more"
alias -g H="|head"
alias -g HH="|&head"
alias -g T="|tail"
alias -g TT="|&tail"
alias -g S="|sort"
alias -g SS="|&sort"
alias -g U="|uniq"
alias -g UU="|&uniq"
alias -g GP="|grep -P"
alias -g GGP="|&grep -P"
alias -g X="|xargs"
alias -g XX="|&xargs"

alias ppp=playvid

alias mytime="TZ=Asia/Bangkok undertime  --no-default-zone Asia/Bangkok UTC US/Pacific Australia/Tasmania"

if [ -z "$VIRTUAL_ENV" ] && [ -f "$PWD"/bin/activate ]; then
  source "$PWD"/bin/activate
fi

if [[ -f "$PROFILE_DIR/zshrc.local.post" ]]; then
  source "$PROFILE_DIR/zshrc.local.post"
fi


# vim:syn=zsh:ft=zsh
