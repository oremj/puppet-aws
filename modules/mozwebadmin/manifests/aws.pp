# Includes configuration for deploying to AWS.
class mozwebadmin::aws(
  $puppet_ip = $ipaddress)
{
    class {
        'mozawsdeploy::config':
            vpc_id    => $::ec2_vpc,
            puppet_ip => $puppet_ip;
    }
}
