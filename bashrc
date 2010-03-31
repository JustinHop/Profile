set -o vi

umask 002

alias srpm="rpmbuild --target i686 --rebuild"
alias rpm="rpm --verbose"
alias A="ACCEPT_KEYWORDS=\"~x86\" "
alias doom3="LD_PRELOAD=/usr/lib/libGL.so.1 doom3"
alias m1='xmodmap -e "pointer = 1 2 3 6 7 4 5"'
alias m2='xmodmap -e "pointer = 1 2 3 7 6 4 5"'
alias ls="ls -F "
alias ifconfig=ipconfig
alias BT="TERM=screen-bce"
alias XT="TERM=xterm "
alias Xterm='xterm +bc -cr red -j +sb -u8 +vb -bd red -bg black -fg green'
alias flux='xinit `which startfluxbox`'
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
alias ,,=".."
alias ks="ls"
alias xs="cd"
alias RN="rename '$_=ls $_; s![ #$/]!_!g;'"
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

alias zsg=zsh
alias zsj=zsh
alias z=zsh

export PS1="<\u@\H> \W \$ "

