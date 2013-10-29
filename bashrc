set -o vi
set -o histexpand

umask 002

if [ -f "~/bin/zsh" ]; then
    ZSH="~/bin/zsh"
else
    Z=$( which zsh-beta )
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

export PS1="<\u@\H> \W \$ "


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

