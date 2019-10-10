#!/bin/bash

#Constants
KEY_FILE=~/.otpkeys
DECRYPT=~/dotfiles/scripts/file-decrypt.sh

#Decrypt the file
$DECRYPT $KEY_FILE.des3

#Recieve a user choice
PS3="Please pick a service: "
services=(` grep ".*@.*=" $KEY_FILE | cut -d"=" -f 1 | sed "s/ //g" `)
select service in "${services[@]}"
do
  break
done

#Get service secret
service_secret=` grep ^$service $KEY_FILE | cut -d"=" -f 2 | sed "s/ //g" `

#Remove encrypted key file
rm -rf $KEY_FILE

# Is service key available?
if [ -z $service_secret ]; then
    echo "Bad Service Name"
    exit
fi

#Calculate totp and copy to clipboard
/usr/local/bin/oathtool --totp -b $service_secret | pbcopy

echo "$service code has copied."

