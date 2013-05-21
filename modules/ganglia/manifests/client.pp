# ganglia client class
class ganglia::client(
    $cluster_name = undef,
    $cluster_owner = undef,
    $recv_host = undef,
    $recv_port = undef,
) {
    package {
        'ganglia-gmond':
            ensure => 'present';
    }

    file {
        '/etc/ganglia/gmond.conf':
            notify  => Service['gmond'],
            require => Package['ganglia-gmond'],
            content => template('ganglia/gmond.conf');
    }

    service {
        'gmond':
            ensure     => 'running',
            hasrestart => true,
            hasstatus  => true;
    }
}
