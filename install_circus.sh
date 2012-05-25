#!/usr/bin/env bash

# Install Mozilla Circus


apt-get update
# for some reason if uninstalled querying for python-dev still exits 0 so i have to install it manually
apt-get -y install python-dev

PACKAGES=( build-essential curl git uuid-dev python-dev python-setuptools python-nose python-profiler )

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


if [ -d /usr/local/zeromq* ]
then
  echo "Directory /usr/local/zeromq already exists!"
else
  url=http://download.zeromq.org/zeromq-2.2.0.tar.gz
  tarfile=${url##*/}        # strip off the part before the last slash
  dir=${tarfile%.tar.gz}    # strip off ".tar.gz"

  cd /tmp/
  wget -q "$url"
  cd /usr/local/
  tar -xzf "/tmp/$tarfile"
  cd "$dir"
  ./configure
  make install
  ldconfig
fi


if [ -d /usr/local/pyzmq* ]
then
  echo "Directory /usr/local/pyzmq already exists!"
else
  url=https://github.com/downloads/zeromq/pyzmq/pyzmq-2.2.0.tar.gz
  tarfile=${url##*/}
  dir=${tarfile%.tar.gz}

  cd /tmp/
  wget -q "$url"
  cd /usr/local/
  tar -xzf "/tmp/$tarfile"
  cd "$dir"
  python setup.py build_ext --inplace
fi


if [ -d /usr/local/circus* ]
then
  echo "Directory /usr/local/circus already exists!"
else
  cd /usr/local/
  git clone https://github.com/mozilla-services/circus.git
  cd /usr/local/circus
  python setup.py install
fi

