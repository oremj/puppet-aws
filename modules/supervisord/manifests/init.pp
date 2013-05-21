# supervisord class
class supervisord {
    file {
        '/etc/supervisord.conf':
            content => template('supervisord/supervisord.conf');
        '/var/log/supervisor':
            ensure => 'directory';
        '/etc/supervisord.conf.d':
            ensure  => 'directory',
            recurse => true,
            purge   => true;

        '/etc/init.d/supervisord':
            mode    => '0755',
            content => template('supervisord/init.erb');
    }

    service {
        'supervisord':
            ensure    => 'running',
            enable    => true,
            restart   => '/usr/bin/supervisorctl update',
            start     => '/sbin/service supervisord start',
            stop      => '/sbin/service supervisord stop',
            hasstatus => true,
            status    => '/sbin/service supervisord status',
            require   => File['/etc/supervisord.conf'];
    }
}
