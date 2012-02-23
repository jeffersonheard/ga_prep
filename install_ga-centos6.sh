#!/bin/bash

if [ -n $HTTP_PROXY ]; then
   alias pip=pip --proxy=$HTTP_PROXY
fi 

# make sure we can install MongoDB
if [ ! -f /etc/yum.repos.d/10gen.repo ]; then
echo "[10gen]" > /etc/yum.repos.d/10gen.repo
echo "name=10gen Repository" >> /etc/yum.repos.d/10gen.repo
echo "baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64" >> /etc/yum.repos.d/10gen.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/10gen.repo
if [ -n $HTTP_PROXY ]; then
	echo "proxy=$HTTP_PROXY" >> /etc/yum.repos.d/10gen.repo
fi
fi

# install RPMs
if [ "$1" != "skip-packages" ]; then
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm
rpm -Uvh http://elgis.argeo.org/repos/6/elgis-release-6-6_0.noarch.rpm
yum -y update
yum -y groupinstall "Development Tools"
yum -y install postgresql postgresql-server postgresql-contrib postgresql-devel readline-devel ncurses-devel libevent-devel glib2-devel libjpeg-devel freetype-devel bzip2 bzip2-devel bzip2-libs openssl-devel pcre pcre-devel gpg make gcc yum-utils unzip gdal geos grass libspatialite osm2pgrouting postgis proj gdal-devel geos-devel grass-devel libspatialite-devel proj-devel hdf5-devel hdf5 netcdf netcdf-devel R-core R-devel mongo-10gen mongo-10gen-server rabbitmq-server git atlas-devel atlas-devel gcc-gfortran atlas
fi

#The GDAL RPM is currently broken for building the python extns, so we have to install GDAL 1.8.1 from source into /usr/local
curl http://download.osgeo.org/gdal/gdal-1.8.1.tar.gz | tar -xz
cd gdal-1.8.1
./configure
make -j2 && make install
cd ..
rm -rf gdal-1.8.1

# Since we're using /usr/local, we need to update the PATH and LD_LIBRARY_PATH
echo 'export PATH=/usr/local/bin:$PATH' >> /etc/profile
echo 'export PYTHONPATH=/usr/lib64/grass-6.4.1/etc/python:$PYTHONPATH' >> /etc/profile
echo 'export LD_LIBRARY_PATH=/usr/local/bin:$LD_LIBRARY_PATH' >> /etc/profile
source /etc/profile

# add django user and create skeleton
if [ ! -d /opt/django ]; then
useradd -d /opt/django -m -r django
passwd django
fi

mkdir -p /opt/django
mkdir -p /opt/django/apps
mkdir -p /opt/django/logs
mkdir -p /opt/django/logs/nginx
mkdir -p /opt/django/logs/apps
mkdir -p /opt/django/configs
mkdir -p /opt/django/scripts
mkdir -p /opt/django/htdocs
mkdir -p /opt/django/htdocs/static
mkdir -p /opt/django/htdocs/media
ln -s /opt/django/htdocs/static /opt/django/htdocs/static/static
ln -s /opt/django/htdocs/media /opt/django/htdocs/media/media
mkdir -p /opt/django/tmp
mkdir -p /opt/django/configs/nginx
mkdir -p /opt/django/configs/supervisord
mkdir -p /opt/django/apps/ga

echo "<html><body>nothing here</body></html> " > /opt/django/htdocs/index.html

# update bash profile to look at /usr/local/*
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/:/usr/local/lib64/" >> /etc/profile
echo "export PATH=$PATH:/usr/local/bin:/usr/local/sbin" >> /etc/profile
source /etc/profile

# download pip and distribute 
mkdir -p /tmp/downloads
cd /tmp/downloads
curl -O http://python-distribute.org/distribute_setup.py
python distribute_setup.py

mkdir -p /tmp/downloads
cd /tmp/downloads
curl -O -k https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py
pip install virtualenv
pip install supervisor

# download and build nginx
mkdir -p /tmp/downloads
cd /tmp/downloads
wget http://nginx.org/download/nginx-1.0.4.tar.gz
tar -xzvf nginx-1.0.4.tar.gz
cd nginx-1.0.4
./configure --sbin-path=/usr/local/sbin --with-http_ssl_module --with-http_stub_status_module
make -j4
/etc/init.d/nginx stop
sleep 2
make install
chmod +x /usr/local/sbin/nginx

# create a virtual environment where geoanalytics will go
cd /opt/django/apps/ga/
virtualenv --distribute --no-site-packages v0.1
touch /opt/django/apps/ga/v0.1/.venv

# grab geoanalytics from GitHub
cd /opt/django/apps/ga/v0.1/
curl -L "https://github.com/JeffHeard/ga_prep/zipball/master" > ga.zip
unzip ga.zip
mv JeffHeard* ga
rm ga.zip

# setup configuration files and paths
ln -s /opt/django/apps/ga/v0.1 /opt/django/apps/ga/current
ln -s /opt/django/apps/ga/current/ga/conf/nginx.conf /opt/django/configs/nginx/myapp.conf
ln -s /opt/django/apps/ga/current/ga/conf/supervisord.conf /opt/django/configs/supervisord/myapp.conf

# activate the ve
source /opt/django/apps/ga/current/bin/activate
cd /opt/django/apps/ga/current/ga/
sh bootstrap.sh

# install geoanalytics apps from GitHub
mkdir -p /opt/django/apps/ga/src
cd /opt/django/apps/ga/src
curl -L "https://github.com/JeffHeard/ga_ows/zipball/master" > ga_ows.zip
unzip ga_ows.zip
mv JeffHeard* ga_ows
rm ga.zip
cd ga_ows
python setup.py install

mkdir -p /tmp/downloads
cd /tmp/downloads
curl -L https://github.com/wpjunior/django-mongotools/zipball/master > django-mongotools.zip
unzip django-mongotools.zip
mv wpjunior* django-mongotools
cd django-mongotools
python setup.py install

# move /etc configuration files into place for nginx 
mkdir -p /etc/nginx
ln -s /opt/django/apps/ga/current/ga/server/etc/nginx.conf /etc/nginx/nginx.conf
ln -s /usr/local/nginx/conf/mime.types /etc/nginx/mime.types
ln -s /opt/django/apps/ga/current/ga/server/init.d/nginx /etc/init.d/nginx
chmod 755 /etc/init.d/nginx
chkconfig --add nginx
chkconfig nginx on

# move /etc configuration files into place for supervisord
ln -s /opt/django/apps/ga/current/ga/server/etc/supervisord.conf  /etc/supervisord.conf
ln -s /opt/django/apps/ga/current/ga/server/init.d/supervisord /etc/init.d/supervisord
chmod 755 /etc/init.d/supervisord
chkconfig --add supervisord
chkconfig supervisord on

# make sure django is owned by its own user
chown -R django:users /opt/django
/etc/init.d/postgresql initdb
sed "s/ident$/trust/g" < /var/lib/pgsql/data/pg_hba.conf > /tmp/pg_hba.conf
cp /tmp/pg_hba.conf /var/lib/pgsql/data/
/etc/init.d/postgresql start

# create postgis database
createdb template_postgis -U postgres
psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';" -U postgres
psql -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql -U postgres# Loading the PostGIS SQL routines
psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql -U postgres
psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;" -U postgres # Enabling users to alter spatial tables.
psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;" -U postgres
psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;" -U postgres
createuser -s -P geoanalytics  -U postgres
createdb -T template_postgis geoanalytics -U geoanalytics

# create celery queues

