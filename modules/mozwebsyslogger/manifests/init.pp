class mozwebsyslogger {
    include rsyslog
    include rsyslog::udpserver

    file {
        '/var/log/clusterlogs':
            mode => '0755',
            ensure => directory;
    }

    rsyslog::config {
        'websyslogger':
            content => template('mozwebsyslogger/syslog.conf');
    }
}
