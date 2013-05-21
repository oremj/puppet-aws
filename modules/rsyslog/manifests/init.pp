# class rsyslog
class rsyslog {
    package {
        'rsyslog':
            ensure => 'present';
        'rsyslog-gnutls':
            ensure => 'present';
    }

    file {
        '/etc/rsyslog.conf':
            require => Package['rsyslog'],
            mode    => '0644',
            content => template('rsyslog/rsyslog.conf'),
            notify  => Service['rsyslog'];

        '/etc/rsyslog.d/':
            ensure  => directory,
            recurse => true,
            purge   => true,
    }

    service {
        'rsyslog':
            ensure     => running,
            enable     => true,
            hasrestart => true,
            hasstatus  => true,
            require    => File['/etc/rsyslog.conf'];
    }
}
