class ganglia::client(
    $cluster_name,
    $cluster_owner,
    $recv_host,
    $recv_port
) {
    package {
        'ganglia-gmond':
            ensure => 'present';
    }

    file {
        '/etc/ganglia/gmond.conf':
            notify => Service['gmond'],
            require => Package['ganglia-gmond'],
            content => template('ganglia/gmond.conf');
    }

    service {
        'gmond':
            ensure => 'running',
            hasrestart => true,
            hasstatus => true;
    }
}
