# Includes configuration for deploying to AWS.
class mozwebadmin::aws {
    class {
        'mozawsdeploy::config':
            vpc_id => $::ec2_vpc;
    }
}
