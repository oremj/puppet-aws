import os
from functools import partial

from fabric.api import execute, settings, sudo, task

from mozdeploy import make
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
def create_web(release_id, instance_type='m1.small', count=1):
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
def deploy_to_admin(ref):
    web.build_app(PROJECT_DIR, ref)
    web.install_app(CLUSTER_DIR, SITE_NAME)


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

    make.python_app_package('solitude',
                            version=ref,
                            repo='git://github.com/mozilla/solitude.git',
                            requirements='requirements/prod.txt',
                            build_dir=build_dir)
