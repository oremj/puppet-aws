class mozwebsyslogger(
    $device = '/dev/xvdf1',
    $tls = true,
    $ca_cert_content = undef,
    $server_cert_content = undef,
    $server_key_content = undef

){
    include rsyslog

    if $tls {
        $inputname = 'tlsin'
        class {
            'rsyslog::tlsserver':
              ca_cert_content     => $ca_cert_content,
              server_cert_content => $server_cert_content,
              server_key_content  => $server_key_content,
        }
    }
    else {
        $inputname = 'imudp'
        include rsyslog::udpserver
    }
    
    mount { 
        '/var/log/clusterlogs':
            device  => "${device}",
            fstype  => 'ext4',
            ensure  => 'mounted',
            options => 'defaults',
            atboot  => 'true',
            require => File['/var/log/clusterlogs'];
    }

    file {
         '/var/log/clusterlogs':
            mode    => '0755',
            ensure  => directory,
    }

    file {
         '/var/log/clusterlogs/hosts':
            mode    => '0755',
            ensure  => directory,
            require => Mount['/var/log/clusterlogs'];
    }

    rsyslog::config {
        'websyslogger':
            require => File['/var/log/clusterlogs/hosts'],
            content => template('mozwebsyslogger/syslog.conf');
    }
}
