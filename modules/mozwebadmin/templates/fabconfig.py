import os

from mozawsdeploy.fabfile import aws
from functools import partial


CLUSTER_DIR = '/data/<%= cluster %>'
SITE_NAME = '<%= site_name %>'
SUBNET_ID = '<%= subnet_id %>'
LB_NAME = '<%= lb_name %>'
INSTANCE_TYPE = '<%= instance_type %>'

PROJECT_DIR = os.path.normpath(os.path.dirname(__file__))

create_server = partial(aws.create_server, subnet_id=SUBNET_ID)
create_web = partial(create_server, server_type='web',
                     instance_type=INSTANCE_TYPE,
                     count=1)
