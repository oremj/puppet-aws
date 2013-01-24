class sentry::service(
  $db_user = 'sentry',
  $db_name = 'sentry',
  $db_password = undef,
  $db_host = undef,
  $port = '3306',
  $sentry_key = undef,
  $secret_key = undef,
  $url_prefix = 'https://somewebsite.mozilla.com',
  $web_host = '0.0.0.0',
  $web_port = '9000',
  $udp_host = '0.0.0.0',
  $udp_port = '9000',
  $workers = '8',
  $broker_url = 'amqp://sentry:',
  $redis_host = 'localhost',
  $redis_port = '6379',
  $email_host = 'localhost',
  $email_host_password = '',
  $email_host_user = '',
  $email_port = '25',
  $email_use_tls = 'False',
  $email_address = 'nobody@mozilla.com'
){
  include sentry
  include nginx
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
        require => File['/etc/sentry/sentry.conf.py'],
    }
  
    supervisord::program {
      'sentry-udp':
        command => '/usr/bin/sentry --config=/etc/sentry/sentry.conf.py start udp',
        cwd     => '/usr/bin',
        user    => 'sentry',
        require => File['/etc/sentry/sentry.conf.py'],
    }
  
    celery::service {
      'sentry':
        command => "/usr/bin/sentry --config=/etc/sentry/sentry.conf.py celeryd -c 4",
        app_dir => '/usr/bin',
        user    => 'sentry',
        require => File['/etc/sentry/sentry.conf.py'],
    }

    # include nginx

    $app_domain = $url_prefix

    $app_name = 'sentry-http'

    nginx::upstream {
        "${app_name}":
            upstream_port => $web_port,
            require       => Package['nginx'];
    }

    nginx::logdir {
        "${app_domain}":
            before       => Package['nginx'];
    }

    nginx::config {
        "${app_domain}":
            content => template('sentry/nginx.conf.erb'),
            require => Package['nginx'];
    }

}
