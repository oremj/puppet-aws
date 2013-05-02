class mozawsdeploy::config(
    $vpc_id,
    $amazon_ami = 'ami-ecbe2adc',
    $region = 'us-west-2',
    $puppet_host = 'puppet'
) {
    $aws_app = $::ec2_app
    $aws_env = $::ec2_env
    $admin_host = $ipaddress

    file {
        '/etc/awsdeploy.puppet':
            content => template('mozawsdeploy/awsdeploy');
    }
}
