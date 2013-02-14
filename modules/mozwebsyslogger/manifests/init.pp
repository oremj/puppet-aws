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
        '/var/log/syslogs':
            device  => "${device}",
            fstype  => 'ext4',
            ensure  => 'mounted',
            options => 'defaults',
            atboot  => 'true',
            require => File['/var/log/syslogs'];
    }

    file {
         '/var/log/syslogs':
            mode    => '0755',
            ensure  => directory,
    }

    file {
         '/var/log/syslogs/apps':
            mode    => '0755',
            ensure  => directory,
            require => Mount['/var/log/clusterlogs'];
         '/var/log/syslogs/hosts':
            mode    => '0755',
            ensure  => directory,
            require => Mount['/var/log/clusterlogs'];
    }

    rsyslog::config {
        'websyslogger':
            require => [File['/var/log/syslogs/hosts'], File['/var/log/syslogs/apps']],
            content => template('mozwebsyslogger/syslog.conf');
    }
}
