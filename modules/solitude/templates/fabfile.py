import os
from functools import partial

from fabric.api import local, task

from mozawsdeploy import ec2
from mozawsdeploy.fabfile import aws, web


PROJECT_DIR = os.path.normpath(os.path.dirname(__file__))

AMAZON_AMI = 'ami-2a31bf1a'
SUBNET_ID = '<%= subnet_id %>'
ENV = '<%= site %>'

SERVER_TYPES = ['syslog', 'celery', 'sentry', 'rabbitmq', 'graphite']

create_server = partial(aws.create_server, app='solitude', ami=AMAZON_AMI,
                        subnet_id=SUBNET_ID, env=ENV)


@task
def create_web(instance_type='m1.small', count=1):
    """
    args: instance_type, count
    This function will create the "golden master" ami for solitude web servers.
    """

    instances = create_server(server_type='web', instance_type=instance_type,
                              count=count)

    elb_conn = ec2.get_elb_connection()
    elb_conn.register_instances('solitude-%s' % ENV, [i.id for i in instances])


@task
def create_instance(server_type, instance_type='m1.small'):
    """
    args: server_type, instance_type.
          Valid server_types are listed in SERVER_TYPES
    """
    assert server_type in SERVER_TYPES

    instances = create_server(server_type=server_type,
                              instance_type=instance_type)
    return instances


@task
def create_security_groups():
    """
    This function will create security groups for the specified env
    """
    env = ENV
    security_groups = ['solitude-base-%s' % env,
                       'solitude-celery-%s' % env,
                       'solitude-graphite-%s' % env,
                       'solitude-graphite-elb-%s' % env,
                       'solitude-rabbitmq-%s' % env,
                       'solitude-rabbitmq-elb-%s' % env,
                       'solitude-sentry-%s' % env,
                       'solitude-sentry-elb-%s' % env,
                       'solitude-syslog-%s' % env,
                       'solitude-web-%s' % env,
                       'solitude-web-elb-%s' % env]

    ec2.create_security_groups(security_groups)


@task
def build_release(ref):
    """Build release. This assumes puppet has placed settings in /settings"""
    def extra(release_dir):
        local('rsync -av %s/aeskeys/ %s/aeskeys/' % (PROJECT_DIR, release_dir))

    web.build_release('solitude', PROJECT_DIR,
                      repo='git://github.com/mozilla/solitude.git', ref=ref,
                      requirements='requirements/prod.txt',
                      settings_dir='solitude/settings', extra=extra)


@task
def remove_old_releases():
    web.remove_old_releases(PROJECT_DIR, keep=4)
