#!/bin/bash

set -a

DEBUG=

function curlit() {
    local CLUSTER_ADDR=$1
    local CLUSTER_IP=$2
    local PUBLIC_NAME=$3
    curl -s -H 'Accept-Encoding: gzip,deflate' \
            -I --resolve $PUBLIC_NAME:80:$CLUSTER_IP \
            --resolve $PUBLIC_NAME:443:$CLUSTER_IP \
            $PUBLIC_NAME
}

function indentit() {
    local TABS=$1
    local TAB=""
    for i in $(seq 1 $TABS) ; do
        TAB="$TAB\t"
    done
    sed "s/^/$TAB/"
}


while read line ; do
    if [ "$line" ]; then
            CLUSTER_ADDR=$(echo $line | cut -d'[' -f1)
            CLUSTER_IP=$(echo $line | cut -d'[' -f2 | cut -d']' -f1)
            PUBLIC_NAME=$(echo $line | cut -d' ' -f2 | cut -d'[' -f1)
        if [ "$DEBUG" ]; then
            echo $line
            echo "CLUSTER_ADDR=$CLUSTER_ADDR"
            echo "CLUSTER_IP=$CLUSTER_IP"
            echo "PUBLIC_NAME=$PUBLIC_NAME"
        fi
        OUTPUT="$(curlit $CLUSTER_ADDR $CLUSTER_IP http://$PUBLIC_NAME/)"
        echo -e "$PUBLIC_NAME @ $CLUSTER_ADDR:$CLUSTER_IP"
        (
            echo "$OUTPUT" | grep HTTP | head -n 1
            echo "$OUTPUT" | grep Location: | head -n 1
            echo "$OUTPUT" | grep Content-Encoding: | head -n 1
            if [ "$DEBUG" ]; then
                echo "FULL"
                echo "$OUTPUT"
            fi
        ) | indentit 1
        LOCATION=$(echo "$OUTPUT" | grep Location: | awk '{ print $2 }')

        if [ "$LOCATION" ]; then
            OUTPUT2="$(curlit $CLUSTER_ADDR $CLUSTER_IP $LOCATION)"
            (
                echo Following Redirect
                echo "$OUTPUT2" | grep HTTP | head -n 1
                echo "$OUTPUT2" | grep Location: | head -n 1
                echo "$OUTPUT2" | grep Content-Encoding: | head -n 1
                if [ "$DEBUG" ]; then
                    echo "FULL"
                    echo "$OUTPUT2"
                fi
            ) | indentit 2
        fi

        LOCATION2=$(echo "$OUTPUT2" | grep Location: | awk '{ print $2 }')
        if [ "$LOCATION2" ]; then
            OUTPUT3="$(curlit $CLUSTER_ADDR $CLUSTER_IP $LOCATION2)"
            (
                echo Following Redirect
                echo "$OUTPUT3" | grep HTTP | head -n 1
                echo "$OUTPUT3" | grep Location: | head -n 1
                echo "$OUTPUT3" | grep Content-Encoding: | head -n 1
                if [ "$DEBUG" ]; then
                    echo "FULL"
                    echo "$OUTPUT3"
                fi
            ) | indentit 3
        fi

        echo
    fi
done
