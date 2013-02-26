import os
from functools import partial

from fabric.api import execute, lcd, local, settings, sudo, task

from apppackr import make
from mozawsdeploy import config, configure, ec2
from mozawsdeploy.fabfile import aws, web


configure()

PROJECT_DIR = os.path.normpath(os.path.dirname(__file__))

CLUSTER_DIR = '/data/<%= cluster %>'
SITE_NAME = '<%= site_name %>'
SUBNET_ID = '<%= subnet_id %>'
ENV = config.env
LB_NAME = '<%= lb_name %>'

create_server = partial(aws.create_server, subnet_id=SUBNET_ID)


@task
def create_web(release_id, instance_type='m1.small', count=1):
    """
    args: instance_type, count
    This function will create the "golden master" ami for solitude web servers.
    """

    instances = create_server(server_type='web',
                              instance_type=instance_type,
                              count=count)

    return instances


@task
def create_security_groups(env=ENV):
    """
    This function will create security groups for the specified env
    """
    security_policy = {
        'admin': {'in': ['celery,web,web-proxy:873/tcp',
                         'celery,web:8080/tcp',
                         'web-proxy:8081/tcp',
                         'base:8140/tcp']},
        'celery': {},
        'base': {'in': ['admin:22/tcp']},
        'db': {'in': ['admin,celery,web:3306/tcp']},
        'graphite': {},
        'graphite-elb': {},
        'rabbitmq': {},
        'rabbitmq-elb': {'in': ['admin,celery,web:5672/tcp']},
        'sentry': {},
        'sentry-elb': {},
        'syslog': {'in': ['base:514/udp']},
        'web': {'in': ['web-elb:81/tcp']},
        'web-elb': {},
        'web-proxy': {'in': ['web-proxy-elb:81/tcp']},
        'web-proxy-elb': {},
    }


    ec2.create_security_policy(security_policy, 'solitude', env)


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
    sudo('supervisorctl restart gunicorn-solitude-payments')


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
    make.python_app_package('solitude',
                            version=ref,
                            repo='git://github.com/mozilla/solitude.git',
                            requirements='requirements/prod.txt',
                            build_dir=build_dir)

    local('rsync -av %s/aeskeys/ %s/aeskeys/' % (PROJECT_DIR, build_dir))
    local('rsync -av %s/settings/ %s/solitude/solitude/settings/' %
          (PROJECT_DIR, build_dir))

    with lcd(os.path.join(build_dir, 'solitude')):
        local('git log --oneline -1 > %s' % os.path.join(build_dir,
                                                         'REVISION'))
