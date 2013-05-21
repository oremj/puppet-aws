# ganglia server class
class ganglia::server {

    include supervisord

    package {
        [
          'ganglia-gmetad',
          'ganglia-web']:
            ensure => 'present';
    }

    file {
        '/etc/ganglia/gmetad.conf':
            notify  => Service['gmetad'],
            require => [
                        File['/etc/ganglia/gmetad.d'],
                        Package['ganglia-gmetad']
            ],
            content => template('ganglia/gmetad.conf');

        '/etc/ganglia/gmetad.d':
            ensure  => 'directory',
            recurse => true,
            purge   => true;

        '/etc/ganglia/gmond.d':
            ensure  => 'directory',
            recurse => true,
            purge   => true;
    }

    service {
        'gmetad':
            ensure     => 'running',
            hasrestart => true,
            hasstatus  => true;
    }

    ganglia::listener {
        'generic':
            gmond_port => '8649';
    }
}
