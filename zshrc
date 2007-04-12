#######################################
#  WORLDWIDE zshrc 
#
#        email me if you like it,
#                 use it, or have suggestions/patches.
#
#  Justin Hoppensteadt 
#              <zshy-goodness@root-squash.ath.cx>
#              http://root-squash.ath.cx
#
#                 free to all
#
#######################################
#######################################

export ZSHRC_VERSION="1.9.9"

if [[ -o login ]]; then
    if [[ ! -d ~/.undo ]]; then
        mkdir ~/.undo
    fi
    if [[ -r /etc/profile ]]; then
        . /etc/profile || echo "/etc/profile errored"
    fi
fi

# localiazation workarounds & functions
for i in "$PROFILE_DIR/include" "$PROFILE_DIR/zshrc.local" "$PROFILE_DIR/zshrc.local.pre" "$HOME/.zshrc"; do
    if [[ -f $i ]]; then
        . $i || echo "$i failed execution."
    fi
done

if [[ -f /etc/zsh/include ]]; then
    source /etc/zsh/include
fi

############################
###  OPERATING SYSTEM DEPS
############################

case $UNAME in
    (UnixWare)
        typeset -a BKT
        BKT=('<' '>' '(' ')' '{' '}')

        alias TAT='export TERM=AT386-ie'
        alias TSCO='export TERM=scoansi'

        if [[ -n $TERMINAL_EMULATOR ]]; then
            export TERM=$TERMINAL_EMULATOR
        fi

        if [[ -a /usr/gnu/bin/ls ]]; then 
            LS="/usr/gnu/bin/ls"
            export GNU_COREUTILS=1
        else
            LSO="-F"
            alias ls="lc $LSO"
            alias l.="lc $LSO -d .* "
            alias la="lc $LSO -a"
            alias ll="lc -l $LSO"
            alias ll."lc -la $LSO"
            alias lc="lc $LSO"
            alias l="lc $LSO"
            alias lsd="lc */ -d"
        fi

        export DISTRO=Unixware
        export MANPATH="/usr/man:/usr/local/man:/usr/gnu/man"
        export PATH="$SCO_PATH:$PATH:$UNIXWARE_PATH"
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/gnu/lib"

        TYCOLOR=white
    ;;

    (SCO_SV)
        typeset -a BKT
        BKT=('{' '}' '<' '>' '[' ']')
        export DISTRO=OpenServer
        export DISTRO_VER=`uname -v`  
        export PATH="$SCO_PATH:$PATH"
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/gnu/lib"
        TYCOLOR=green
    ;;

    (SunOS)
        if [[ $ZSH_VERSION = 3.* ]]; then
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

        for i in "$HOME/toolbox" /m1/utility/toolbox ; do
            if [[ -d "$i" ]]; then
                TBOX="$i"
            fi
        done

        if [[ -d $TBOX ]]; then
            box=$TBOX
            PROFILE_DIR=$TBOX/etc
            PATH="$TBOX/bin:$PATH"
            MANPATH="$TBOX/man:$TBOX/share/man:/usr/local/man:/usr/local/share/man:/usr/man:/usr/share/man:$MANPATH"
            if [[ -x `whence gls` ]]; then
                LS=`whence gls`
                export GNU_COREUTILS=1
            fi
        fi

        export LD_LIBRARY_PATH="$TBOX/lib:$LD_LIBRARY_PATH:${SUN_PATH:gs/bin/lib/}"

        # I'll use these ones later
        #CFLAG32="-fast -s -xthreadvar=dynamic -xarch=v8plusa -mc -xbinopt=prepare -xO4"
        #CFLAG64="-fast -s -xthreadvar=dynamic -xarch=v9a -mc -xbinopt=prepare -xO4"

        if [[ -x `whence cc` ]]; then
            #if cc -V &| grep -s "Sun" ; then
                export CC=cc
                export CFLAGS="-fast -s -xarch=v9a "
                export ADD_FLAGS=$CFLAGS
                export LDFLAGS="-L $TBOX/lib \$ADD_FLAGS"
                export CXX=CC
                export CXXFLAGS=$CFLAGS
                #export CPPFLAGS="-I $TBOX/include $CFLAGS"
            #fi
        fi

        if [ -n $STY$RUNNING_SCREEN$SCREEN_SCREEN ]; then
            if [[ -x $TBOX/bin/vim ]]; then
                #if `toe | grep -s xtermc ` ; then
                #   VIM_TERM="TERM=xtermc"
                #fi
            fi
            # This needs to be fixed
            # alias less=" TERM=vt220 less "
            # alias man=" TERM=vt220 man "
        fi

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

        if tty | grep pts > /dev/null ; then
            if whence fgconsole > /dev/null ; then
                LIN=`tty|tr '/' ' '|awk '{ print $3 }'`
                LIN_SCREEN="`fgconsole`:$LIN"
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
    ;;
esac

export PATH

###################################
# TERMINAL SETTINGS AND KEYBINDINGS
###################################
case $TERM in
    # FN_CHARS=( INSERT HOME PGUP DELETE END PGDN )
    (*xterm*||dtterm||Eterm||*rxvt*)
        FN_CHARS=( '^[[2~' '^[[H' '^[[5~'
                    '^[[3~' '^[[F' '^[[6~' )

        bindkey '^[[1~' vi-beginning-of-line   #home   
        bindkey '^[[4~' vi-end-of-line         #end

        #rxvt uglyness
        bindkey '^[[7~' vi-beginning-of-line   #home   
        bindkey '^[[8~' vi-end-of-line         #end
        if [[ $UNAME == "SunOS" ]]; then
            STM="-T xterm"
            alias BT="TERM=screen-bce"
            TSCR=" -T screen-bce "
        fi
        bindit
    ;;
    (*linux*)
        FN_CHARS=( '^[[2~' '^[[1~' '^[[5~'
                    '^[[3~' '^[[4~' '^[[6~' )
        VIM_LINUX_TERM=" -c ':set t_Co=16' "
#        if `whence termck` ; then
#            if `termck screen.linux` ; then
#                STM=screen.linux
#            fi
#        fi
        bindit
    ;;
    (*screen*)
        FN_CHARS=( '^[[2~' '^[[1~' '^[[5~'
                    '^[[3~' '^[[4~' '^[[6~' )
        SQL_TERM="TERM=xterm "
        alias XT="TERM=xterm "
        whence svccfg > /dev/null && alias svccfg="TERM=xterm svccfg"
        if [[ -z $STY ]]; then
            STY=a
        fi
        bindit
    ;;
    (*vt*)
        FN_CHARS=( '^[[2~' '^[OH' '^[[5~'
                    '^[[4~' '^[OF' '^[[6~'  )
        bindit
    ;;
    (*ansi*)
        if [[ -f /etc/termcap ]]; then
            if grep -e '\<scoansi\>' /etc/termcap* 2&>/dev/null ; then
                export TERM=scoansi
            fi
        fi
    ;;
    (*)
        FN_CHARS=( '^[[2~' '^[[1~' '^[[5~'
                    '^[[3~' '^[[4~' '^[[6~' )
        bindit
    ;;
esac

# reguardless - they CANT mean anything else
bindkey '^[OH' vi-beginning-of-line             # home
bindkey '^[OF' vi-end-of-line                   # end

#  some defaults
#  ^U    clear line
#  ^R    hist search
#  cmdG + int, int rev hist line
#  ^G    list expands
  
#  Mine
#  ^N    repeat search
#  ^P    rev search
#  ^B    History expansion

bindkey '^W' accept-and-menu-complete
bindkey '^N' vi-repeat-find
bindkey '^P' vi-rev-repeat-find
bindkey '^B' expand-history

if [[ $ZSH_VERSION = 4.* ]]; then
	bindkey '^O' all-matches
fi
    
##################################
# ALIAS
##################################

alias Xterm='xterm +bc -cr red -j +sb -u8 +vb -bd red -bg black -fg green'
alias flux='xinit `which startfluxbox`'

alias d=dirs
alias pu=pushd
alias po=popd
alias m=mail
alias j=jobs
alias psa="ps -A $TREEPS"
alias kew="echo 'Totally.'"

# oops'
alias ,,=".."
alias ks="ls"
alias xs="cd"

# good idea
alias -g "..."="../.."
alias -g "...."="../../.."
alias -g "....."="../../../.."
alias -g "......"="../../../../.."
alias -g "......."="../../../../../.."
alias -g "........"="../../../../../../.."
alias -g "........."="../../../../../../../.."
alias -g ".........."="../../../../../../../../.."

#####################################
# GNU LS ALIASES
#####################################

if [[ $GNU_COREUTILS -eq 1 ]]; then
    export GREP_COLOR=auto

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

if [[ -f $PROFILE_DIR/dircolors ]]; then
    ZLS_COLORS=`cat $PROFILE_DIR/dircolors`
    export LS_COLORS=$ZLS_COLORS
fi
unset CDPATH

# ViM
if [[ -x `whence vim` ]]; then
    export EDITOR=vim
    export VISUAL=vim
    if [[ -n $VIM_COLOR ]]; then
        VIM=$VIM" -c ':colorscheme $VIM_COLOR' "
    fi
    VIM=$VIM$VIM_LINUX_TERM
    alias vim="$VIM"
    alias vi="$VIM"
    alias v="$VIM"
    export EDITOR="$VIM"
fi

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
alias -g NIL=" 2&> /dev/null "
alias -g NULL=" 2&>1 /dev/null "

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
if [[ -x `whence konqueror` ]]; then
    alias konqu='konqueror --profile filemanagement '
fi

# the mighty screen
if [[ -x `whence screen` ]]; then
    alias screen="screen -a -s $0 -O -q $ZSCR $SLOGS $STM"
fi

# oracle stuff
alias sqldba="$SQL_TERM sqlplus '/ as sysdba'"
if [[ -x `whence gqlplus` ]]; then
    alias gqldba="gqlplus '/ as sysdba' -dc "
fi

#######################################
# My Options
#######################################
setopt  \
    NO_allexport \
    auto_cd \
    autolist \
    automenu \
    autopushd \
    auto_param_keys \
    auto_param_slash \
    auto_remove_slash \
    nobeep \
    NObgnice \
    braceccl \
    cdablevars \
    completeinword \
    correct \
    NO_nullglob \
    extendedglob \
    NO_flowcontrol \
    functionargzero \
    globassign \
    globcomplete \
    nohup \
    longlistjobs \
    magicequalsubst \
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
    histfindnodups \
    histignorespace \
    histignoredups \
    histreduceblanks \
    histverify \
    incappendhistory 

# env vars for history
export HISTFILE=~/.zhistory
export HISTSIZE=65535
export SAVEHIST=65000

# bindings for history
#bindkey "^XH" set-local-history

if [[ $ZSH_VERSION = 4.* ]]; then
    setopt aliases \
        listpacked \
        promptpercent 
fi

if [[ $ZSH_VERSION = 3.* ]]; then
    setopt listtypes \
        mark_dirs \
        menu_complete \
        rc_expand_param \
        zle \
        NOverbose \
        NOsingle_line_zle
fi

################################################
# The following lines were added by compinstall
################################################
if [[ $ZSH_VERSION = 4.* ]]; then
    zstyle ':completion:*' auto-description 'specify: %d'
    #zstyle ':completion:*' completer _list _expand _complete _match _correct _approximate
    zstyle ':completion:*' completer _complete _expand  _match _correct _list _approximate
    zstyle ':completion:*' completions 1
    zstyle ':completion:*' format 'zcomp: %d'
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
    zstyle ':completion:*' matcher-list '' 'r:|[._-]=* r:|=*'
    zstyle ':completion:*' max-errors 2
    zstyle ':completion:*' menu select=5
    zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

    autoload -U compinit
    compinit
fi
# End of lines added by compinstall

###############################################
 ### completion goodness from zshwiki.org
##############################################
if [[ $ZSH_VERSION = 4.* ]]; then
    # use cache
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path ~/.zsh/cache

    # ignore lost&found
    zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found'

    # CLEAR OUT THAT DAMNED CD COMPLETION GARBAGE!!!
    zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust \
        lp mail mailnull named news nobody nscd \
        ntp operator pcap postgres radvd rpc rpcuser rpm \
        shutdown squid sshd sync uucp vcsa xfs backup  bind  \
        dictd  gnats  identd  irc  man  messagebus  postfix \
        proxy  sys  www-data

    # no functions for programs i dont have
    zstyle ':completion:*:functions' ignored-patterns '_*'

    # hostname completion!!!
    if [[ -f $HOME/.ssh/known_hosts ]]; then
        myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
        zstyle ':completion:*' hosts $myhosts;
    fi
    if [[ -f /etc/ssh/known_hosts ]]; then
        ourhosts=( ${${${${(f)"$(</etc/ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
        zstyle ':completion:*' hosts $ourhosts;
    fi
fi

###############################################
 # COLOR FUNCTIONS
################################################
I_WANT_COLORS="yes"
if [[ $ZSH_VERSION = 3.* ]]; then
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

###############################################
# PROMPT MADNESS
################################################
if [[ $ZSH_VERSION = 4.* ]]; then
   autoload -U colors
   colors
fi
   
[ -z $BKT[1] ] && BKT=( '[' ']' '{' '}' '<' '>' )
[ -z $SSH_CLIENT ] && HOSCOL="red" || HOSCOL="green"

if [[ $ZSH_VERSION = 3.* ]]; then
    local D="${default}"
    local R="${red}"
    local G="${green}"
    local B="${blue}"
    #local TYCOLOR=`eval echo $"${TYCOLOR}"`
else 
    local BL="%{${bg_no_bold[black]}}"
    local D="%{${fg_no_bold[default]}%}"
    local R="%{${fg_no_bold[red]}%}"
    local G="%{${fg_no_bold[green]}%}"
    local B="%{${fg_bold[blue]}%}"
fi


if [[ -n $STY && -n $WINDOW ]]; then
    if [[ -n $LIN_SCREEN ]]; then
        J="${LIN_SCREEN}:${WINDOW}"
    else
        J="%l:${WINDOW}"
    fi
else
    J="%l"
fi

if [[ $ZSH_VERSION = 3.* ]]; then
    local PLVL="$START$R%2(L.%L.)$D"
    local PJOB="%1(j.$G${BKT[1]}%j${BKT[2]}.)$D"
    local PUID="$R(%(#.$R/.${blue}%n)$R)$D"
    local PPWD="${violet}:$D%1~"
    local PMAR="${violet}%#${D}"
    local PTT="\$${TYCOLOR}${BKT[5]}${J}${BKT[6]}${D}"
    local PHOS="$D@\$${HOSCOL}%m$D"

    PS1=$(print '$PLVL$PJOB${BKT[3]}$PTT$PUID$PHOS$PPWD${BKT[4]} $PMAR ')
    #RPROMPT="%0(?..${red}%?${default})"
else
    local PLVL="$R%2(L.%L.)$D"
    local PJOB="%1(j.$G${BKT[1]}%j${BKT[2]}.)$D"
    local PUID="$R(%(#.$R/.%{${fg_bold[blue]}%}%n)$R)$D"
    local PPWD="%{${fg_no_bold[violet]}%}:$D%1~"
    local PMAR="%{${fg_no_bold[violet]}%}%(!.$.%%)$D"
    if [[ -z $ORACLE_SID ]]; then
        local PTT="%{${fg[${TYCOLOR}]}%}${BKT[5]}${J}${BKT[6]}$D"
    else
        local PTT="%{${fg[${TYCOLOR}]}%}${BKT[5]}\${ORACLE_SID}${BKT[6]}$D"
    fi
    local PHOS="$D@%{${fg_no_bold[${HOSCOL}]}%}%m$D"

    PS1="$PLVL$PJOB${BKT[3]}$PTT$PUID$PHOS$PPWD${BKT[4]} $PMAR "
    RPROMPT="%0(?..%{${fg_no_bold[red]}%}%?%{${fg_no_bold[default]}%})"
fi   

###################################
## From zshwiki.org   "its cool"
###################################

if [[ -f $TBOX/system-name ]]; then
    SYSTEM_NAME="[`cat $TBOX/system-name`] "
fi

################################################
#  postexec
################################################ 

if [[ -f $PROFILE_DIR/include ]]; then
    . $PROFILE_DIR/include 
fi

if [[ -f $PROFILE_DIR/zshrc.local.post ]]; then
    . $PROFILE_DIR/zshrc.local.post
fi

