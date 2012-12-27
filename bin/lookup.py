#!/bin/env python
## return puppet class information based on aws tags

from boto.ec2 import connect_to_region, regions
import sys
import yaml

region = 'us-west-2'
aws_access_key_id = ''
aws_secret_access_key = ''
fqdn = sys.argv[1]
filters = {'tag:Project': 'amo',
           'private_dns_name': fqdn,
          }

def get_type(filters):
    try:
        conn = connect_to_region(region, aws_access_key_id=aws_access_key_id,
                                 aws_secret_access_key=aws_secret_access_key)
        reservations = conn.get_all_instances(filters=filters)
        if not reservations:
            sys.exit('Host not found')
        else:
            return reservations[0].instances[0].tags
    except:
        print sys.exc_info()

def create_yaml(tags):  
    tclass = "%s::%s::%s" % (tags['App'], tags['Type'], tags['Env'])
    pclass =  tclass.encode('ascii','ignore')
    data = {"classes": [pclass] }
             
    print yaml.dump(data, default_flow_style=False, indent=10)

tags=get_type(filters)
create_yaml(tags)
