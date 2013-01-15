class mozwebsyslogger(
    $device = '/dev/xvdf1'
){
    include rsyslog
    include rsyslog::udpserver
    
    mount { 
        '/var/log/clusterlogs':
            device  => "${device}",
            fstype  => 'ext4',
            ensure  => 'mounted',
            options => 'defaults',
            atboot  => 'true',
    }

    file {
         ['/var/log/clusterlogs/hosts']:
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
