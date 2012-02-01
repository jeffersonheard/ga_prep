#!/bin/bash

if [ -z $VIRTUAL_ENV ]; then
    source ../bin/activate
fi

if [ -n $HTTP_PROXY ]; then
    alias pip=pip --proxy=$HTTP_PROXY
fi

mkdir custom
cd custom
wget http://cairographics.org/releases/pycairo-1.8.8.tar.gz
tar -xzf pycairo-1.8.8.tar.gz
cd pycairo-1.8.8
./configure
make && make install
cd ../..
pip install `cat requirements.txt | egrep -v "^#" | tr "\n" " "`
