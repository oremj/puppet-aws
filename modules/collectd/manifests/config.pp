class collectd::config(
    $collectd_hostname,
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
