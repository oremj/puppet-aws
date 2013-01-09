class statsd::service {

  include supervisord
  include statsd
  include statsd::config
  $node = '/usr/bin/node'
  $statsd = '/usr/bin/statsd'
  $config = $statsd::config::config

  supervisord::program {
    'statsd':
      command => "${node} ${statsd} $config",
      cwd     => "/usr/bin",
      user    => 'statsd',
      require => [
                  Class['statsd::config'],
                  Class['statsd'],
      ],
  }
}
