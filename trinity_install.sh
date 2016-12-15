#!/bin/bash

## capstone-engine
cd /tmp
git clone https://github.com/aquynh/capstone.git
cd capstone && mkdir build && cd build
cmake .. && make install && cd ..
cd bindings/python
make install install3
# quick n dirty fix but please feel free to rtfm/improve
ln -s /usr/local/lib/libcapstone.so /usr/local/lib/python2.7/dist-packages/capstone-3.0.4-py2.7.egg/capstone/libcapstone.so
ln -s /usr/local/lib/libcapstone.so /usr/local/lib/python3.4/dist-packages/capstone-3.0.4-py3.4.egg/capstone/libcapstone.so

## keystone-engine
cd /tmp
git clone https://github.com/keystone-engine/keystone.git
cd keystone && mkdir build && cd !$
cmake .. && make install && cd ..
cd bindings/python
make install install3

## unicorn-engine
sudo apt-get install pkg-config libglib2.0-dev -y
cd /tmp
git clone https://github.com/unicorn-engine/unicorn.git
cd unicorn && ./make.sh && ./make.sh install
cd bindings/python
make install install3

rm -fr /tmp/capstone /tmp/keystone /tmp/unicorn
