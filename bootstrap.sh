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

pip install Django
pip install fabric
pip install gunicorn
pip install gdal
pip install numpy
pip install numpy # this is not redundant, surprisingly.  scipy won't install unless you do this twice.
pip install numpy
pip install scipy
pip install psycopg2
pip install pyke
pip install shapely
pip install mongoengine
pip install pymongo
pip install celery
pip install django-celery
pip install django-tastypie
pip install ipython
pip install NetCDF4
pip install cython
pip install numexpr
pip install tables
