# Include Apache with mod_ssl.  Note that this is rarely used, as most of the
# SSL stuff at Mozilla is done via Zeus.

class apache::mod_ssl {
    include apache

    package {
        'mod_ssl':
            ensure => latest,
            notify => Service['httpd'];
    }
}
