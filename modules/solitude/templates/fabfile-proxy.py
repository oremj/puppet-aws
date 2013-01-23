import os
import time
from functools import partial

from fabric.api import lcd, local, task

from mozawsdeploy import ec2
from mozawsdeploy.fabfile import aws, web


PROJECT_DIR = os.path.normpath(os.path.dirname(__file__))

CLUSTER_DIR = '/data/<%= cluster %>'
SITE_NAME = '<%= site_name %>'
AMAZON_AMI = 'ami-2a31bf1a'
SUBNET_ID = '<%= subnet_id %>'
ENV = '<%= site %>'
LB_NAME = '<%= lb_name %>'

create_server = partial(aws.create_server, app='solitude', ami=AMAZON_AMI,
                        subnet_id=SUBNET_ID, env=ENV)


@task
def create_proxy(release_id, instance_type='m1.small', count=1):
    """
    args: instance_type, count
    This function will create the "golden master" ami for solitude web servers.
    """

    instances = create_server(server_type='web-proxy',
                              instance_type=instance_type,
                              count=count)

    for i in instances:
        i.add_tag('Release', release_id)

    return instances


@task
def deploy(ref, wait_timeout=900):
    """Deploy a new version"""
    local('%s/build/%s "%s"' % (CLUSTER_DIR, SITE_NAME, ref))
    local('%s/bin/install-app %s LATEST' % (CLUSTER_DIR, SITE_NAME))

    release_dir = os.path.join(PROJECT_DIR, 'current')

    venv = os.path.join(release_dir, 'venv')
    python = os.path.join(venv, 'bin',  'python')
    app = os.path.join(release_dir, 'solitude')
    with lcd(app):
        local('%s %s/bin/schematic migrations' % (python, venv))

    instances = create_proxy(ref, count=4)
    new_inst_ids = [i.id for i in instances]

    print 'Sleeping for 5 min while instances build.'
    time.sleep(300)
    print 'Waiting for instances (timeout: %ds)' % wait_timeout
    aws.wait_for_healthy_instances(LB_NAME, new_inst_ids, wait_timeout)
    print 'All instances healthy'
    print '%s is now running' % ref


@task
def build_release(ref, build_id, build_dir):
    """Build release. This assumes puppet has placed settings in /settings"""

    r_id = web.build_release('solitude', PROJECT_DIR,
                             repo='git://github.com/mozilla/solitude.git',
                             ref=ref,
                             requirements='requirements/prod.txt',
                             settings_dir='solitude/settings',
                             build_dir=build_dir, release_id=build_id)

    return r_id
