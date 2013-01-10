class mozwebsyslogger {
    include rsyslog
    include rsyslog::udpserver

    file {
        ['/var/log/clusterlogs',
         '/var/log/clusterlogs/hosts']:
            mode => '0755',
            ensure => directory;
    }

    rsyslog::config {
        'websyslogger':
            require => File['/var/log/clusterlogs/hosts'],
            content => template('mozwebsyslogger/syslog.conf');
    }
}
