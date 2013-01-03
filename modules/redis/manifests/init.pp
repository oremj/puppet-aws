class redis {
  include yum::base

  package {
    'redis':
      ensure  => present,
      require => Class['yum::base'],
  }

  service {
    'redis':
      ensure  => running,
      enable  => true,
      require => Package['redis'],
  }
}
