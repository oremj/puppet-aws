# redis class
class redis {
  include base::yum

  package {
    'redis':
      ensure  => present,
      require => Class['base::yum'],
  }

  service {
    'redis':
      ensure  => running,
      enable  => true,
      require => Package['redis'],
  }
}
