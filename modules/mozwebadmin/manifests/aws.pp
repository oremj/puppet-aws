# Includes configuration for deploying to AWS.
class mozwebadmin::aws(
  $puppet_host = 'puppet')
{
    class {
        'mozawsdeploy::config':
            vpc_id    => $::ec2_vpc,
            puppet_host => $puppet_host;
    }
}
