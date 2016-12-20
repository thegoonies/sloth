#!/bin/bash

set -e

## capstone-engine
cd /tmp
git clone https://github.com/aquynh/capstone.git
cd capstone && mkdir build && cd build
cmake .. && make install && cd ..
cd bindings/python
make install install3

## keystone-engine
cd /tmp
git clone https://github.com/keystone-engine/keystone.git
cd keystone && mkdir build && cd build
sed -i 's/make -j8/make/g' ../make-share.sh
../make-share.sh && make install
cd ../bindings/python
make install install3

## unicorn-engine
sudo apt-get install pkg-config libglib2.0-dev -y
cd /tmp
git clone https://github.com/unicorn-engine/unicorn.git
cd unicorn && ./make.sh && ./make.sh install
cd bindings/python
make install install3

rm -fr -- /tmp/capstone /tmp/keystone /tmp/unicorn
