#!/usr/bin/env bash

# Install Mozilla Circus

apt-get -q -y install build-essential curl git uuid-dev python-dev python-setuptools python-nose python-profiler


if [ -f /usr/lib/libzmq.so ]
then
  echo "File /usr/lib/libzmq.so already exist"
else
  url=http://download.zeromq.org/zeromq-2.2.0.tar.gz
  tarfile=${url##*/}
  dir=${tarfile%.tar.gz}

  cd /tmp/
  wget -q "$url"
  cd /usr/local/
  tar -xzf "/tmp/$tarfile"
  cd "$dir"
  ./configure
  make install
  ldconfig
fi


if [ -d /usr/local/lib/python2.7/dist-packages/pyzmq-2.2.0-py2.7-linux-x86_64.egg ]
then
  echo "File /usr/local/pyzmq-2.2.0 already exists"
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


if [ -d /usr/local/circus ]
then
  echo "Directory /usr/local/circus already exists!"
else
  cd /usr/local/
  git clone https://github.com/mozilla-services/circus.git
  cd /usr/local/circus
  python setup.py install
fi

