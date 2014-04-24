set -o vi
set -o histexpand

umask 002

if [ -f "~/bin/zsh" ]; then
    ZSH="~/bin/zsh"
else
    Z=$( which zsh-beta 2>/dev/null)
    if [[ -x $Z ]]; then
        ZSH=$Z
    fi
    unset Z
fi

alias srpm="rpmbuild --target i686 --rebuild"
alias rpm="rpm --verbose"
alias ifconfig=ipconfig
alias Xterm='xterm +bc -cr red -j +sb -u8 +vb -bd red -bg black -fg green'
alias d=dirs
alias pu=pushd
alias po=popd
alias m=mail
alias j=jobs
alias b='export BACKUP=-'
alias B='export BACKUP=+'
alias psa="ps -Af f" 
alias kew="echo 'Totally.'"
alias orly="echo yarly"
alias ..="cd .."
alias ,,="cd .."
alias ks="ls"
alias xs="cd"
alias W="ssh -l jhoppensteadt localhost -p 2222 -i ~/work"

LS=/bin/ls
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

alias zsg=$ZSH
alias zsj=$ZSH
alias z=$ZSH

alias J="ssh jhoppensteadt@justin2.sys.dev99.websys.tmcs"

parse_git_dirty () {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}
color_tester () {
  echo ${BASE03}BASE03, ${BASE02}BASE02, ${BASE01}BASE01, \
    ${BASE00}BASE00, ${BASE0}BASE0, ${BASE1}BASE1, \
    ${BASE2}BASE2, ${BASE3}BASE3, ${YELLOW}YELLOW, \
    ${ORANGE}ORANGE, ${RED}RED, ${MAGENTA}MAGENTA, \
    ${VIOLET}VIOLET, ${BLUE}BLUE, ${CYAN}CYAN, \
    ${GREEN}GREEN, ${BOLD}BOLD, ${RESET}RESET
}
setup_env () {
if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp
gnome-256color >/dev/null 2>&1; then TERM=gnome-256color; fi
if tput setaf 1 &> /dev/null; then
  tput sgr0
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    BASE03=$(tput setaf 234)
    BASE02=$(tput setaf 235)
    BASE01=$(tput setaf 240)
    BASE00=$(tput setaf 241)
    BASE0=$(tput setaf 244)
    BASE1=$(tput setaf 245)
    BASE2=$(tput setaf 254)
    BASE3=$(tput setaf 230)
    YELLOW=$(tput setaf 136)
    ORANGE=$(tput setaf 166)
    RED=$(tput setaf 160)
    MAGENTA=$(tput setaf 125)
    VIOLET=$(tput setaf 61)
    BLUE=$(tput setaf 33)
    CYAN=$(tput setaf 37)
    GREEN=$(tput setaf 64)
  else
    BASE03=$(tput setaf 8)
    BASE02=$(tput setaf 0)
    BASE01=$(tput setaf 10)
    BASE00=$(tput setaf 11)
    BASE0=$(tput setaf 12)
    BASE1=$(tput setaf 14)
    BASE2=$(tput setaf 7)
    BASE3=$(tput setaf 15)
    YELLOW=$(tput setaf 3)
    ORANGE=$(tput setaf 9)
    RED=$(tput setaf 1)
    MAGENTA=$(tput setaf 5)
    VIOLET=$(tput setaf 13)
    BLUE=$(tput setaf 4)
    CYAN=$(tput setaf 6)
    GREEN=$(tput setaf 2)
  fi
  BOLD=$(tput bold)
  RESET=$(tput sgr0)
else
  # Linux console colors. I don't have the energy
  # to figure out the Solarized values
  MAGENTA="\033[1;31m"
  ORANGE="\033[1;33m"
  GREEN="\033[1;32m"
  PURPLE="\033[1;35m"
  WHITE="\033[1;37m"
  BOLD=""
  RESET="\033[m"
fi

#       [INFO]<USER@FQDN:PWD>-[HOSTINFO]-
#       <EXIT>[JOBS]/TTY $

_P_LT="\[${BOLD}${BASE2}\]<"
_P_GT="\[${BOLD}${BASE2}\]>"
_P_AT="\[${BOLD}${BASE2}\]@"
_P_C="\[${BOLD}${BASE2}\]:"
_P_USER="\[${BOLD}${CYAN}\]\u"
_P_HOST="\[$CYAN\]\H"
_P_PWD="\[$BLUE\]\w"
_P_LINE1="${_P_LT}${_P_USER}${_P_AT}${_P_HOST}${_P_C}${_P_PWD}${_P_GT}"
PS1="${_P_LINE1}\n\[${BOLD}${BASE3}\]\$ \[$RESET\]"

export PS1

export PAGER=less
export EDITOR=vim
export LS_COLORS='no=00:fi=00:di=34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:'
export LESS=-isaFMXRU
export MANLESS=-isaFMXR
alias ,,='cd ..'
alias ..='cd ..'
alias J='ssh jhoppensteadt@justin2.sys.dev99.websys.tmcs'
alias d='dirs'
alias j='jobs'
alias ks='ls'
alias l='/bin/ls --color=always -C -F '
alias l.='/bin/ls  --color=auto --hide-control-chars --classify  -d .* '
alias la='/bin/ls  --color=auto --hide-control-chars --classify  -A '
alias lh.='/bin/ls  --color=auto --hide-control-chars --classify  -dsh .* '
alias ll='/bin/ls  --color=auto --hide-control-chars --classify  -lB '
alias ll.='/bin/ls  --color=auto --hide-control-chars --classify  -dlB .*'
alias llh='/bin/ls  --color=auto --hide-control-chars --classify  -lshB'
alias lls='/bin/ls  --color=auto --hide-control-chars --classify  -lsB'
alias ls='/bin/ls  --color=auto --hide-control-chars --classify  -B '
alias ls.='/bin/ls  --color=auto --hide-control-chars --classify  -d -B .* '
alias lsa='/bin/ls  --color=auto --hide-control-chars --classify  -AB '
alias lsc='/bin/ls --color=always -C -F -B'
alias lsd='/bin/ls  --color=auto --hide-control-chars --classify  -d *(-/) '
alias lsf='/bin/ls  --color=auto --hide-control-chars --classify  -d *(-.) '
alias lsh='/bin/ls  --color=auto --hide-control-chars --classify  -shB'
alias lsln='/bin/ls  --color=auto --hide-control-chars --classify  -d *(#q@) '
alias lss='/bin/ls  --color=auto --hide-control-chars --classify  -s'
alias m='mail'
alias po='popd'
alias psa='ps -Af f'
alias pu='pushd'
alias rpm='rpm --verbose'
alias sl='/bin/ls  --color=auto --hide-control-chars --classify  -B -r'
alias xs='cd'
alias z='/bin/zsh-beta'
alias zsg='/bin/zsh-beta'
alias zsj='/bin/zsh-beta'
set -o vi
}

function elite
{

local GRAY="\[\033[1;30m\]"
local LIGHT_GRAY="\[\033[0;37m\]"
local CYAN="\[\033[0;36m\]"
local LIGHT_CYAN="\[\033[1;36m\]"
local NO_COLOUR="\[\033[0m\]"

case $TERM in
    xterm*|rxvt*)
        local TITLEBAR='\[\033]0;\u@\h:\w\007\]'
        ;;
    *)
        local TITLEBAR=""
        ;;
esac

local temp=$(tty)
local GRAD1=${temp:5}
PS1="$TITLEBAR\
$GRAY-$CYAN-$LIGHT_CYAN(\
$CYAN\u$GRAY@$CYAN\h\
$LIGHT_CYAN)$CYAN-$LIGHT_CYAN(\
$CYAN\#$GRAY/$CYAN$GRAD1\
$LIGHT_CYAN)$CYAN-$LIGHT_CYAN(\
$CYAN\$(date +%h%M)$GRAY/$CYAN\$(date +%d-%b-%y)\
$LIGHT_CYAN)$CYAN-$GRAY-\
$LIGHT_GRAY\n\
$GRAY-$CYAN-$LIGHT_CYAN(\
$CYAN\$$GRAY:$CYAN\w\
$LIGHT_CYAN)$CYAN-$GRAY-$LIGHT_GRAY " 
PS2="$LIGHT_CYAN-$CYAN-$GRAY-$NO_COLOUR "
}
setup_env
