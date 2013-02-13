class ntpd (
  $ntp_servers,
){

    package {
        'ntp':
            ensure => present
    }

    file {
        '/etc/ntp.conf':
          ensure  => present,
          content => template('ntpd/ntp.conf.erb'),
          notify  => Service['ntpd'],
    }

    service {
        'ntpd':
            ensure  => running,
            require => Package['ntp'],
    }

}
