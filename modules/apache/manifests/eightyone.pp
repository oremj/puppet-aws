# apache port 81
class apache::eightyone {
    include apache

    file {
        '/etc/httpd/conf.d/00-81.conf':
            require => Package['httpd'],
            notify  => Service['httpd'],
            content => 'Listen 81\nNameVirtualHost *:80\nNameVirtualHost *:81';
    }
}
