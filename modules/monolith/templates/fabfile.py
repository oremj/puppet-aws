from apppackr import make
from fabric.api import task
from mozawsdeploy.fabfile import aws, web

import fabconfig


@task
def localdeploy(ref):
    web.build_app(fabconfig.PROJECT_DIR, ref)
    web.install_app(fabconfig.CLUSTER_DIR, fabconfig.SITE_NAME)


@task
def deploy(ref, servers=4, wait_timeout=900):
    """Deploy a new version"""

    localdeploy(ref)
    aws.deploy_instances_and_wait(create_instance=fabconfig.create_web,
                                  lb_name=fabconfig.LB_NAME,
                                  ref=ref, count=servers,
                                  wait_timeout=wait_timeout)


@task
def build(ref, build_id, build_dir):
    make.python_app_package('monolith',
                            version=ref,
                            repo='git://github.com/mozilla/monolith.git',
                            requirements='requirements/prod.txt',
                            build_dir=build_dir)