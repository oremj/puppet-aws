# collectd config class
class collectd::config(
    $collectd_hostname = undef,
    $graphite_server = undef
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
