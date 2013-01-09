class apache {

    package {
        'httpd':
            ensure => latest,
            notify => Service["httpd"],
            name   => $::osfamily ? {
              'Linux' => 'httpd',
              'RedHat' => 'httpd',
              'Debian' => 'apache2'
            };
        'httpd24':
            ensure => absent;

    }
    # make sure httpd is always running and configured to start at boot
    service {
        'httpd':
            ensure     => running,
            enable     => true,
            hasrestart => true,
            hasstatus  => true,
            restart    => "/usr/sbin/apachectl graceful",
            start      => "/usr/sbin/apachectl start",
            status     => "/etc/init.d/httpd status",
            require    => Package['httpd'],
            name       => $::osfamily ? {
              'Linux' => 'httpd',
              'RedHat' => 'httpd',
              'Debian' => 'apache2'
            };
    }

}
