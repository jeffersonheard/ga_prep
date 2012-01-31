from __future__ import with_statement
from fabric.api import *
from fabric.contrib.console import confirm
from fabric.contrib.files import exists

def update_server():
    code_dir = '/opt/django/apps/ga/current/ga/'
    with settings(user='django'):
        with cd(code_dir):
            # pull down and update, could be replaced with hg fetch if turned on.
            run('git pull')
            run("chown -R django:django *")
            run("/opt/django/apps/ga/current/bin/python manage.py syncdb")
            run('find -name "*.pyc" -delete')
            run("supervisorctl restart ga")
            run('supervisorctl status')
            
            
            
