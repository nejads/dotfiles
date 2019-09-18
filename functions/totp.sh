#!/bin/sh

#Install oath-toolkit if it is not installed
check_oath=`brew list | grep 'oath-toolkit'`
if [ -z "$check_oath" ]
then
   echo "istalling oath-toolkit...";
   brew install oath-toolkit;
fi

#Check argument count
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 SECRET" >&2
  exit 1
fi

secret=$1
oathtool --totp -b $secret | pbcopy
echo "Your totp has copied to clipboard."

