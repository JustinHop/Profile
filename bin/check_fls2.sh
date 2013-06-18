#!/bin/bash
#===============================================================================
#
#          FILE:  check_fls2.sh
# 
#         USAGE:  ./check_fls2.sh 
# 
#   DESCRIPTION:  Continuous check of filer
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#       COMPANY:  Live Nation
#       VERSION:  1.0
#       CREATED:  07/14/2012 01:20:26 PM PDT
#      REVISION:  ---
#===============================================================================

TESTFP=$1
LOCKDIR=~/tmp

filer_percent(){
    ssh tdb3.tmol.els0.websys.tmcs df -P | grep oradata | grep fls2 | awk '{ print $5 }' | tr -d '%'
    #echo 95
}

destroy_lock(){
    if [ -f "$LOCKDIR/LOCK_$1" ]; then
        echo "destroying lock $1"
        rm "$LOCKDIR/LOCK_$1"
    fi
}

create_lock(){
    echo "creating lock $1"
    touch "$LOCKDIR/LOCK_$1"
}

check_lock(){
    if [ -f "$LOCKDIR/LOCK_$1" ]; then
        return 0
    else
        return 1
    fi
}

alert(){
    echo "Alerting at $1%"
    echo "Please contact the websys oncall and tell 
    them that tdb3.tmol.els0.websys.tmcs:/tdb/oracle/oradata 
    is at $1%" | mail -s "tdb3.tmol.els0.websys.tmcs:/tdb/oracle/oradata at $1" websys@ticketmaster.com gms@ticketmaster.com

}

run_check(){
    FP=`filer_percent`
    #FP=$TESTFP
    if [ $FP -lt 95 ]; then
        echo "$FP is under 95%: Condition Good."
        destroy_lock 95
        destroy_lock 98
        destroy_lock 99
    elif [ $FP -lt 98 ]; then
        echo "$FP is over 95%: Alerting if necessary."
        if check_lock 95 ; then
            echo " - Already alerted."
        else
            echo " - Alerting."
            alert $FP
            create_lock 95
        fi
        destroy_lock 98
        destroy_lock 99
    elif [ $FP -lt 99 ]; then
        echo "$FP is over 98%: Alerting if necessary."
        if check_lock 98 ; then
            echo " - Already alerted."
        else
            echo " - Alerting."
            alert $FP
            create_lock 98
            create_lock 95
        fi
        destroy_lock 99
    elif [ $FP -gt 98 ]; then
        echo "$FP is OVER 99%: Alerting if necessary."
        if check_lock 99; then
            echo " - Already alerted."
        else
            echo " - Alerting."
            alert $FP
            create_lock 95
            create_lock 98
            create_lock 99
        fi
    else
        echo "$FP: OUT OF RANGE"
    fi
}

while true ; do
    run_check
    sleep 1m
done



#lock_create 95
#if check_lock 95 ; then echo yes ; else echo no ; fi
#destroy_lock 95
#if check_lock 95 ; then echo yes ; else echo no ; fi


