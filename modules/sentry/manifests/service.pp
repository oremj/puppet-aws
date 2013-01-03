class sentry::service(
  $debug = 'False',
  $db_user = 'sentry',
  $db_name = 'sentry',
  $db_password = undef,
  $db_host = undef,
  $port = '3306',
  $sentry_key = 'undef',
  $secret_key = 'undef',
  $url_prefix = 'https://somewebsite.mozilla.com',
  $web_host = '0.0.0.0',
  $web_port = '9000',
  $udp_host = '0.0.0.0',
  $udp_port = '9000',
  $workers = '8',
  $broker_url = 'amqp://sentry:',
  $redis_host = 'localhost',
  $redis_port = '6379'
){
  include sentry
  include supervisord

  file { '/etc/sentry':
      ensure  => directory,
      mode    => '0755',
      owner   => 'sentry',
      group   => 'root',
      require => Class['sentry'],
  }

  file { '/etc/sentry/sentry.conf.py':
      ensure  => present,
      content => template("${module_name}/sentry.conf.py.erb"),
      mode    => 0644,
      owner   => 'sentry',
      group   => 'root',
      require => File['/etc/sentry'],
  }

  supervisord::program {
    'sentry-http':
      command => '/usr/bin/sentry --config=/etc/sentry/sentry.conf.py start http',
      cwd     => '/usr/bin',
      user    => 'sentry',
      require => [ File['/etc/sentry/sentry.conf.py'],
                   Class['supervisord'],
      ]
  }

  supervisord::program {
    'sentry-udp':
      command => '/usr/bin/sentry --config=/etc/sentry/sentry.conf.py start udp',
      cwd     => '/usr/bin',
      user    => 'sentry',
      require => [ File['/etc/sentry/sentry.conf.py'],
                   Class['supervisord'],
      ]
  }

  celery::service {
    'sentry':
      command => "/usr/bin/sentry --config=/etc/sentry/sentry.conf.py celeryd -c 4",
      app_dir => '/usr/bin',
      user    => 'sentry',
      require => File['/etc/sentry/sentry.conf.py'],
  }

}
