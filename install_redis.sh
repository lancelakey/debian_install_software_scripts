#!/usr/bin/env bash

# Install Redis

apt-get update

PACKAGES=( build-essential curl )

for PACKAGE in "${PACKAGES[@]}"
do
  if dpkg-query -W --showformat='${Status}\n' $PACKAGE
  then
    echo $PACKAGE is already installed.
  else
    echo $PACKAGE was not already installed. Installing $PACKAGE:
    apt-get -y install $PACKAGE
  fi
done


if [ -d /usr/local/redis* ]
then
  echo "Directory /usr/local/redis already exists!"
else
  url=http://download.redis.io/redis-stable.tar.gz
  tarfile=${url##*/}        # strip off the part before the last slash
  dir=${tarfile%.tar.gz}    # strip off ".tar.gz"

  cd /tmp/
  wget -q "$url"
  cd /usr/local/
  tar -xzf "/tmp/$tarfile"
  cd "$dir"
  make install
fi
