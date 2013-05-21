# graphite carbon service
class graphite::carbon::service {

  service { 'carbon-cache':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['carbon'],
  }

  cron {
      'cleanup-carbon-cache':
          command => '/bin/find /var/log/carbon-cache -type f -mtime +1 -name "*log*" -delete > /dev/null 2>&1',
          user    => root,
          minute  => '1',
          hour    => '2';
  }
}


