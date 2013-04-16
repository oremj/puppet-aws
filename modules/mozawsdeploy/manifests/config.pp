class mozawsdeploy::config(
    $vpc_id,
    $amazon_ami = 'ami-2a31bf1a',
    $region = 'us-west-2',
    $puppet_ip = $ipaddress
) {
    $aws_app = $::ec2_app
    $aws_env = $::ec2_env
    $admin_ip = $ipaddress

    file {
        '/etc/awsdeploy.puppet':
            content => template('mozawsdeploy/awsdeploy');
    }
}
