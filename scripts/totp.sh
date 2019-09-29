#!/bin/sh

#Check argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 service_name" >&2
  exit 1
fi

SERVICE_NAME=$1
KEY_FILE=~/.otpkeys
DECRYPT=~/dotfiles/scripts/file-decrypt.sh

#Decrypt the file
$DECRYPT $KEY_FILE.des3

#Read the file and
SERVICE_KEY=` grep ^$SERVICE_NAME $KEY_FILE | cut -d"=" -f 2 | sed "s/ //g" `

#Remove plain text key file
rm -rf $KEY_FILE

# Is service key available?
if [ -z $SERVICE_KEY ]; then
    echo "Bad Service Name"
    exit
fi

#Calculate totp and copy to clipboard
/usr/local/bin/oathtool --totp -b $SERVICE_KEY | pbcopy

echo "\nYour "$SERVICE_NAME" 2FA has copied."

