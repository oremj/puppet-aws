class statsd::config (
  $graphite_host = 'localhost',
  $graphite_port = '2003',
  $port = '8125',
  $flush_interval = '10'
){
  $config = '/etc/statsd.js'

  file{ $config:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/statsd.js.erb"),
  }
}
