# Django settings for myapp project.

DEBUG = True
TEMPLATE_DEBUG = DEBUG

ADMINS = (
    # ('Your Name', 'your_email@example.com'),
)

MANAGERS = ADMINS

DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis', # Add 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'geoanalytics',                      # Or path to database file if using sqlite3.
        'USER': 'geoanalytics',                      # Not used with sqlite3.
        'PASSWORD': 'geonalytics',                  # Not used with sqlite3.
        'HOST': '',                      # Set to empty string for localhost. Not used with sqlite3.
        'PORT': '',                      # Set to empty string for default. Not used with sqlite3.
    }
}

### Celery Settings
#
BROKER_URL='amqp://geoanalytics:geoanalytics@localhost:5672' # if the broker is running on another machine, change this.  If you have a distributed setup, your other machines' will need to change to use the central broker.
CELERY_RESULT_BACKEND='amqp'
CELERY_TASK_RESULT_EXPIRES=3600 # Task results expire in one hour if they are unconsumed.  

# For more on the following settings, see http://celery.readthedocs.org/en/latest/userguide/routing.html
#CELERY_QUEUES={ 
#    'default' : { 'exchange' : 'default', 'binding_key' : 'default' },
#    'irods' : { 'exchange' : 'irods', 'binding_key' : 'irods.ibatch' },
#}
#CELERY_DEFAULT_QUEUE='default'
#CELERY_DEFAULT_EXCHANGE='tasks'
#CELERY_DEFAULT_EXCHANGE_TYPE='topic'
#CELERY_DEFAULT_ROUTING_KEY='task.default'
#
#class MyRouter(object):
#    def route_for_task(self, task, args=None, kwargs=None):
#         """Rewrite this to do complex task routing"""
#         if task == "myapp.tasks.compress_video":
#              return {"exchange": "video",
#                      "exchange_type": "topic",
#                      "routing_key": "video.compress"}
#         return None
#
#CELERY_ROUTES=(MyRouter(),} # uncomment this line if you're uysing the MyRouter class.
#CELERY_ROUTES=({"ga_irods.tasks.ibatch": {
#                        "queue": "irods",
#                        "routing_key": "irods.ibatch"
#                 }}, )

### IRODS Settings.  Use if ga_irods is installed.  IRODS must be installed on
# the same machine running celeryd with the queue that processes IRODS commands.
# by default, this is 'default', but it can be configured using the Celery settings 
# above.
#
#ICOMMANDS_PATH=/opt/local/irods/clients/icommands/bin

### Descartes settings.  Use if ga_descartes is installed.
# 
# This is the path that descartes writes all rule bases to.  
#RULE_ROOT=/opt/django/ga/current/rules

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# On Unix systems, a value of None will cause Django to use the same
# timezone as the operating system.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = 'America/Chicago'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'en-us'

SITE_ID = 1

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = True

# If you set this to False, Django will not format dates, numbers and
# calendars according to the current locale
USE_L10N = True

# Absolute filesystem path to the directory that will hold user-uploaded files.
# Example: "/home/media/media.lawrence.com/media/"
MEDIA_ROOT = '/opt/django/htdocs/media/'

# URL that handles the media served from MEDIA_ROOT. Make sure to use a
# trailing slash.
# Examples: "http://media.lawrence.com/media/", "http://example.com/media/"
MEDIA_URL = '/media/'

# Absolute path to the directory static files should be collected to.
# Don't put anything in this directory yourself; store your static files
# in apps' "static/" subdirectories and in STATICFILES_DIRS.
# Example: "/home/media/media.lawrence.com/static/"
STATIC_ROOT = '/opt/django/htdocs/static/'

# URL prefix for static files.
# Example: "http://media.lawrence.com/static/"
STATIC_URL = '/static/'

# URL prefix for admin static files -- CSS, JavaScript and images.
# Make sure to use a trailing slash.
# Examples: "http://foo.com/static/admin/", "/static/admin/".
ADMIN_MEDIA_PREFIX = '/static/admin/'

# Additional locations of static files
STATICFILES_DIRS = (
    # Put strings here, like "/home/html/static" or "C:/www/django/static".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
)

# List of finder classes that know how to find static files in
# various locations.
STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
#    'django.contrib.staticfiles.finders.DefaultStorageFinder',
)

# Make this unique, and don't share it with anybody.
SECRET_KEY = '4v6v=8*obdu0&z0#%14c+_0!#8-_$q!!cwuxtaml*!s6gz3#hi'

# List of callables that know how to import templates from various sources.
TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.Loader',
    'django.template.loaders.app_directories.Loader',
)

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
)

ROOT_URLCONF = 'ga.urls'

TEMPLATE_DIRS = (
    # Put strings here, like "/home/html/django_templates" or "C:/www/django/templates".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
    '/opt/django/apps/ga/v0.1//lib/python2.7/site-packages/django/contrib/gis/templates'
)

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django.contrib.admin',
    'django.contrib.admindocs',
    
    # Geoanalytics components. Uncomment to install
    'tastypie',			# Simple RESTful API. Install ga_tastypie extensions from the src directory as well.
    'ga_ows',			# WFS, WMS, (WCS will come as well as SOS) services. WMS Caching requires MongoDB.
    # 'ga_irods',		# IRODS celery task support
    # 'ga_descartes',		# Pyke inference engine with Geoanalytics extensions.  Used for dynamic application configuration or whatever else you find useful.  http://pyke.sourceforge.net
    # 'ga_datacube',		# 5-D regular gridded data. Requires MongoDB.
    # 'ga_sensorcollection',	# Metadata rich sensor collections. Requires MongoDB.
    # 'ga_pyramid',		# Image pyramids.  Requires MongoDB

    # Custom applications go below this line
)

# A sample logging configuration. The only tangible logging
# performed by this configuration is to send an email to
# the site admins on every HTTP 500 error.
# See http://docs.djangoproject.com/en/dev/topics/logging for
# more details on how to customize your logging configuration.
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '%(levelname)s %(asctime)s %(module)s %(process)d %(thread)d %(message)s'
        },
        'simple': {
            'format': '%(levelname)s %(message)s'
        },
    },
    'filters': { },
    'handlers': {
        'null': {
            'level':'DEBUG',
            'class':'django.utils.log.NullHandler',
        },
        'console':{
            'level':'DEBUG',
            'class':'logging.StreamHandler',
            'formatter': 'simple'
        },
        'mail_admins': {
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler',
        }
    },
    'loggers': {
        'django': {
            'handlers':['console'],
            'propagate': True,
            'level':'INFO',
        },
        'django.request': {
            'handlers': ['console'],
            'level': 'ERROR',
            'propagate': False,
        }
    }
}
