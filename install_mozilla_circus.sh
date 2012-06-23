#!/usr/bin/env bash

# Install Mozilla Circus

apt-get -q -y update
apt-get -q -y install build-essential wget git uuid-dev python-dev python-setuptools python-pip


if [[ `whereis -b libzmq` =~ 'libzmq.so' ]]
then
  echo "whereis indicates zeromq is already installed"
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


if [[ `pip freeze | grep -i pyzmq` =~ 'pyzmq' ]]
then
  echo "pip freeze indicates pyzmq is already installed"
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


if [[ `pip freeze | grep -i circus` =~ 'circus' ]]
then
  echo "pip freeze indicates circus is already installed"
else
  cd /usr/local/
  git clone https://github.com/mozilla-services/circus.git
  cd /usr/local/circus
  python setup.py install
fi

