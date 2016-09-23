#!/bin/bash

## capstone-engine
cd /tmp
git clone https://github.com/aquynh/capstone.git
cd capstone && mkdir build && cd !$
cmake .. && make install && cd ..
cd bindings/python
make install install3

## keystone-engine
cd /tmp
git clone https://github.com/keystone-engine/keystone.git
cd keystone && mkdir build && cd !$
cmake .. && make install && cd ..
cd bindings/python
make install install3

## unicorn-engine
# todo

rm -fr /tmp/capstone /tmp/keystone
