# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'
alias d=dirs
alias m=mail
alias j=jobs

# oops'
alias ,,=".."
alias ks="ls"
alias xs="cd"

# Basic directory operations
#alias ...='cd ../..'
alias -- -='cd -'

# good idea
alias -g "..."="../.."
alias -g "...."="../../.."
alias -g "....."="../../../.."
alias -g "......"="../../../../.."
alias -g "......."="../../../../../.."
alias -g "........"="../../../../../../.."
alias -g "........."="../../../../../../../.."
alias -g ".........."="../../../../../../../../.."

# Prevent headaches
#alias cp='cp -v'
#alias rm='rm -v'
#alias mv='mv -v'

# Super user
alias _='sudo'
alias please='sudo'

#alias g='grep -in'

# Show history
if [ "$HIST_STAMPS" = "mm/dd/yyyy" ]
then
    alias history='fc -fl 1'
elif [ "$HIST_STAMPS" = "dd.mm.yyyy" ]
then
    alias history='fc -El 1'
elif [ "$HIST_STAMPS" = "yyyy-mm-dd" ]
then
    alias history='fc -il 1'
else
    alias history='fc -l 1'
fi
# List direcory contents
NOR=" --color=auto --hide-control-chars --classify "

export LS=`which ls`

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

alias afind='ack-grep -il'

