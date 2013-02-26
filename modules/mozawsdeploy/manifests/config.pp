class mozawsdeploy::config(
    $vpc_id,
    $region = 'us-west-2'
) {
    $aws_app = $::ec2_app
    $aws_env = $::ec2_env
    $puppet_ip = $ipaddress

    file {
        '/etc/awsdeploy.puppet':
            content => template('mozawsdeploy/awsdeploy');
    }
}
