class apache::standardconfig {
    include apache
    include apache::eightyone

    file {
        '/etc/httpd/conf.d/00-custom.conf':
            ensure  => file,
            notify  => Service['httpd'],
            require => Package['httpd'],
            source  => 'puppet:///modules/apache/00-custom.conf';
    }
}
