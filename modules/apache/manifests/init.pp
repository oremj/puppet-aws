# apache class
class apache {

    $apache_name = $::osfamily ? {
        'Linux'  => 'httpd',
        'RedHat' => 'httpd',
        'Debian' => 'apache2'
    }
    package {
        'httpd':
            ensure => latest,
            notify => Service['httpd'],
            name   => $apache_name;

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
            restart    => '/usr/sbin/apachectl graceful',
            start      => '/usr/sbin/apachectl start',
            status     => '/etc/init.d/httpd status',
            require    => Package['httpd'],
            name       => $apache_name;
            }
}
