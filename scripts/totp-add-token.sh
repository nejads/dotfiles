#!/bin/sh

# Constants
encrypt=~/dotfiles/scripts/file-encrypt.sh
decrypt=~/dotfiles/scripts/file-decrypt.sh
file_path=~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Secrets

# Parameter
token="$@"
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <service_name=token>" >&2
  exit
fi

# Decrypt the file and put token in the last line. Then, Encrypt the file and remove the decrypted file.
if sh $decrypt "$file_path"/otpkeys.des3; then
  echo "$token" >> "$file_path"/otpkeys

  if sh $encrypt "$file_path"/otpkeys; then
    rm -rf "$file_path"/otpkeys
    echo "Added "$token" to "$file_path"/otpkeys"
  else
    rm -rf "$file_path"/otpkeys
    echo "Couldn't encrypt "$file_path"/otpkeys"
  fi

else
  echo "Couldn't decrypt "$file_path"/otpkeys"
fi
