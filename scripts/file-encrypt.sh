#!/bin/bash
# a script to encrypt files using openssl

FNAME=$1

if [[ -z "$FNAME" ]]; then
    echo "$scriptname <name of file>"
    echo "  - $scriptname is a script to encrypt files using des3"
    exit
fi

openssl des3 -salt -in "$FNAME" -out "$FNAME.des3"