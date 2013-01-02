class mozwebsyslogger {
    include rsyslog
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
