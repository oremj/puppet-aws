class xinetd {
    package {
        'xinetd':
            ensure => 'present';
    }

    service {
        'xinetd':
            ensure => 'running',
            require => Package['xinetd'],
            enable => true,
            status => '/etc/init.d/xinetd status',
            restart => '/etc/init.d/xinetd reload',
            hasstatus => true,
            hasrestart => true;
    }
}
