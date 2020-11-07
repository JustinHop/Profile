#!/bin/bash

set -euo pipefail
#IFS=$'\t\n'

set -x

SAFE="echo"
#SAFE=""

handledir() {
    if (( $# >= 1 )); then
        pushd "$1"
        for FI in * ; do
            if [[ -f "$FI" ]]; then
                CREATED=$(stat -L --format='%Y' "$FI")
                if (( $CREATED != 0 )) ; then
                    DATESTRING=$(date --date="@$CREATED" +%Y-%m)
                    FULLDATESTRING=$(date --date="@$CREATED" +%F)

                    if (( $# == 2 )); then
                        DATESTRING=$FULLDATESTRING
                    fi

                    DATESTRING=$(echo $DATESTRING|sed 's!-!/!g')

                    if [[ ! -d $DATESTRING ]]; then
                        $SAFE mkdir -p $DATESTRING
                    fi

                    $SAFE mv -v "$FI" "$DATESTRING"
                fi
            fi
        done
        popd
    fi
}

DIRLIST=$PWD
if (( $# >= 1 )); then
    DIRLIST="$@"
fi

for _D in $DIRLIST ; do
    echo $_D
    handledir $_D
done
