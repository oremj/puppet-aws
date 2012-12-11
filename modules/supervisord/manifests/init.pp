class supervisord {
    file {
        '/etc/supervisord.conf':
            content => template('supervisord/supervisord.conf');
        '/var/log/supervisor':
            ensure => 'directory';
        '/etc/supervisord.conf.d':
            ensure => 'directory',
            recurse => true,
            purge => true;
    }

    service {
        'supervisord':
            ensure => 'running',
            restart => '/usr/bin/supervisorctl update',
            start => '/usr/bin/supervisord -c /etc/supervisord.conf',
            stop => '/usr/bin/supervisorctl shutdown',
            hasstatus => false,
            require => File['/etc/supervisord.conf'];
    }
}
