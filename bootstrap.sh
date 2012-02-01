#!/bin/bash

./bootstrap.py

mkdir custom
cd custom
wget http://cairographics.org/releases/pycairo-1.8.8.tar.gz
tar -xzf pycairo-1.8.8.tar.gz
cd pycairo-1.8.8
./configure
make && make install

