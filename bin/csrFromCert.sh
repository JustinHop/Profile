#!/bin/bash

ORIGINAL_CERTIFICATE_FILE=$1
if [ -z "$2" ]
then
    NEW_CERTIFICATE_NAME=`
    echo $ORIGINAL_CERTIFICATE_FILE \
        | perl -pe 's#.*?([^/]+)\.crt#$1#'
    `
else
    NEW_CERTIFICATE_NAME=$2
fi

echo "[$NEW_CERTIFICATE_NAME]"

SUBJECT=`
cat $ORIGINAL_CERTIFICATE_FILE \
    | openssl x509 -subject -noout \
    | cut -d\  -f2-
`
echo "Subject [$SUBJECT]"

openssl req \
    -out ${NEW_CERTIFICATE_NAME}.csr \
    -new \
    -newkey rsa:2048 \
    -nodes \
    -keyout ${NEW_CERTIFICATE_NAME}.key \
    -subj "$SUBJECT"

