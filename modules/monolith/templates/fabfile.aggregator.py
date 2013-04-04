import os

from apppackr import make
from fabric.api import execute, lcd, local, settings, sudo, task
from mozawsdeploy.fabfile import aws, web
from mozawsdeploy import ec2

import fabconfig


@task
def localdeploy(ref):
    web.build_app(fabconfig.PROJECT_DIR, ref)
    web.install_app(fabconfig.CLUSTER_DIR, fabconfig.SITE_NAME)


@task
def remote_install_app():
    sudo('puppet agent --test')


@task
def deploy(ref):
    """Deploy a new version"""

    localdeploy(ref)
    instance = ec2.get_instances_by_tags({'Type': 'aggregator'})
    if not instance:
        aws.create_server('aggregator', subnet_id=fabconfig.SUBNET_ID)
    elif len(instance) > 1:
        raise Exception('More than one aggregator instance exists')
    else:
        with settings(hosts=[instance[0].private_ip_address]):
            execute(remote_install_app)


@task
def build(ref, build_id, build_dir):
    make.python_app_package('monolith-aggregator',
                            version=ref,
                            repo='git://github.com/mozilla/monolith-aggregator.git',
                            requirements='requirements/prod.txt',
                            build_dir=build_dir)

    with lcd(os.path.join(build_dir, 'monolith-aggregator')):
        local('../venv/bin/python setup.py develop')

    with lcd(build_dir):
        local('./venv/bin/virtualenv --relocatable ./venv')

    local('rsync -av %s/ %s/' % (
        os.path.join(fabconfig.PROJECT_DIR, 'settings'),
        os.path.join(build_dir, 'configs')))
