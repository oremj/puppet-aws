import os
from functools import partial

from fabric.api import execute, lcd, local, settings, sudo, task

from apppackr import make
from mozawsdeploy import ec2
from mozawsdeploy.fabfile import aws, web


PROJECT_DIR = os.path.normpath(os.path.dirname(__file__))

CLUSTER_DIR = '/data/<%= cluster %>'
SITE_NAME = '<%= site_name %>'
AMAZON_AMI = 'ami-2a31bf1a'
SUBNET_ID = '<%= subnet_id %>'
ENV = '<%= site %>'
LB_NAME = '<%= lb_name %>'

SERVER_TYPES = ['syslog', 'celery', 'sentry', 'rabbitmq', 'graphite']

create_server = partial(aws.create_server, app='solitude', ami=AMAZON_AMI,
                        subnet_id=SUBNET_ID, env=ENV)


@task
def create_web(release_id, instance_type='m1.small', count=1):
    """
    args: instance_type, count
    This function will create the "golden master" ami for solitude web servers.
    """

    instances = create_server(server_type='web',
                              instance_type=instance_type,
                              count=count)

    for i in instances:
        i.add_tag('Release', release_id)

    return instances


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
def create_security_groups(env=ENV):
    """
    This function will create security groups for the specified env
    """
    security_groups = []
    admin = ec2.SecurityGroup('admin',
                              [ec2.SecurityGroupInbound('tcp',
                                                        873, 873, ['web',
                                                                   'web-proxy',
                                                                   'celery']),
                               ec2.SecurityGroupInbound('tcp',
                                                        8080, 8080, ['web',
                                                                     'celery']),
                               ec2.SecurityGroupInbound('tcp',
                                                        8081, 8081, ['web-proxy']),
                               ec2.SecurityGroupInbound('tcp',
                                                        8140, 8140, ['base'])])

    base = ec2.SecurityGroup('base',
                             [ec2.SecurityGroupInbound('tcp',
                                                       22, 22, ['admin'])])

    base = ec2.SecurityGroup('db',
                             [ec2.SecurityGroupInbound('tcp',
                                                       3306, 3306, ['admin',
                                                                    'celery',
                                                                    'web'])])

    rabbit_elb = ec2.SecurityGroup('rabbitmq-elb',
                                   [ec2.SecurityGroupInbound('tcp',
                                                             5672, 5672,
                                                             ['web',
                                                              'admin',
                                                              'celery'])])

    syslog = ec2.SecurityGroup('syslog',
                               [ec2.SecurityGroupInbound('udp',
                                                         514, 514, ['base'])])

    web = ec2.SecurityGroup('web',
                            [ec2.SecurityGroupInbound('tcp',
                                                      81, 81, ['web-elb'])])

    web_proxy  = ec2.SecurityGroup('web-proxy',
                                   [ec2.SecurityGroupInbound('tcp',
                                                             81, 81, ['web-proxy-elb'])])

    security_groups.append(admin)
    security_groups.append(base)
    security_groups.append(db)
    security_groups.append(rabbit_elb)
    security_groups.append(syslog)
    security_groups.append(web)
    security_groups.append(web_proxy)

    security_groups += [ec2.SecurityGroup('celery'),
                        ec2.SecurityGroup('graphite'),
                        ec2.SecurityGroup('graphite-elb'),
                        ec2.SecurityGroup('rabbitmq'),
                        ec2.SecurityGroup('sentry'),
                        ec2.SecurityGroup('sentry-elb'),
                        ec2.SecurityGroup('web-proxy-elb'),
                        ec2.SecurityGroup('web-elb')]

    ec2.create_security_groups(security_groups, 'solitude', env)


@task
def deploy_to_admin(ref):
    web.build_app(PROJECT_DIR, ref)
    web.install_app(CLUSTER_DIR, SITE_NAME)

    release_dir = os.path.join(PROJECT_DIR, 'current')

    venv = os.path.join(release_dir, 'venv')
    python = os.path.join(venv, 'bin',  'python')
    app = os.path.join(release_dir, 'solitude')
    with lcd(app):
        local('%s %s/bin/schematic migrations' % (python, venv))


@task
def remote_install_app(build_id='LATEST'):
    web.remote_install_app(CLUSTER_DIR, SITE_NAME, build_id)
    sudo('kill -HUP $(supervisorctl pid gunicorn-solitude-payments)')


@task
def fastdeploy(ref):
    """Deploys a new version using existing web servers"""
    deploy_to_admin(ref)

    web_servers = ec2.get_instances_by_lb(LB_NAME)
    with settings(hosts=[i.private_ip_address for i in web_servers]):
        execute(remote_install_app)


@task
def deploy(ref, wait_timeout=900):
    """Deploy a new version"""

    deploy_to_admin(ref)
    aws.deploy_instances_and_wait(create_instance=create_web, lb_name=LB_NAME,
                                  ref=ref, count=4,
                                  wait_timeout=wait_timeout)


@task
def build_release(ref, build_id, build_dir):
    """Build release. This assumes puppet has placed settings in /settings"""
    def extra(release_dir):
        local('rsync -av %s/aeskeys/ %s/aeskeys/' % (PROJECT_DIR, release_dir))
        local('rsync -av %s/settings/ %s/solitude/solitude/settings/' %
              (PROJECT_DIR, release_dir))

    make.python_app_package('solitude',
                            version=ref,
                            repo='git://github.com/mozilla/solitude.git',
                            requirements='requirements/prod.txt',
                            extra=extra,
                            build_dir=build_dir)
