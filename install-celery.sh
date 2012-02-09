# Use this on a machine with no celery installation.  It will create the proper users and such for you

if [ -z $1 ]; then
   echo "Usage: install-celery.sh vhost-name"
   exit 1 
fi

rabbitmqctl add_user geoanalytics geoanalytics
rabbitmqctl add_vhost $1
rabbitmqctl set_permissions -p $1 geoanalytics ".*" ".*" ".*"
