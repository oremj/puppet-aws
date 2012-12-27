#!/bin/env python
## return puppet class information based on aws tags

from boto.ec2 import connect_to_region, regions
import sys
import yaml
import os
import ConfigParser

config_file = "%s/.aws.cfg" % os.path.dirname(os.path.realpath(__file__))
config = ConfigParser.RawConfigParser()
config.read(config_file)

region = config.get('aws', 'region')
aws_id = config.get('aws', 'id')
aws_secret = config.get('aws', 'secret')

fqdn = sys.argv[1]
filters = {'tag:Project': 'amo',
           'private_dns_name': fqdn,
          }


def get_type(filters):
    try:
        conn = connect_to_region(region, aws_access_key_id=aws_id,
                                 aws_secret_access_key=aws_secret)
        reservations = conn.get_all_instances(filters=filters)
        if not reservations:
            sys.exit('Host not found')
        else:
            return reservations[0].instances[0].tags
    except:
        print sys.exc_info()
        sys.exit(1)


def create_yaml(tags):
    tclass = "%s::%s::%s" % (tags['App'], tags['Type'], tags['Env'])
    pclass = tclass.encode('ascii', 'ignore')
    data = {"classes": [pclass]}
    print yaml.dump(data, default_flow_style=False, indent=10)

create_yaml(get_type(filters))
