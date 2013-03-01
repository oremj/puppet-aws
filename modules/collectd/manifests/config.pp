class collectd::config(
    $graphite_server
){
  include collectd
  file {
    '/etc/collectd.conf':
        ensure  => present,
        content => template('collectd/collectd.conf.erb'),
        notify  => Service['collectd'],
        require => Package['collectd'];
  }
}
