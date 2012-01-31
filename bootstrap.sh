#!/bin/bash

./bootstrap.py

mkdir custom
cd custom
wget http://cairographics.org/releases/py2cairo-1.8.8.tar.gz
tar -xzf py2cairo-1.8.8.tar.gz
cd py2cairo-1.10.0
./configure
make && make install

