class sentry {

  include sentry::user
  include base::yum
  include redis
 
  package {
    [
      'python-devel',
      'python-eventlet'
    ]:
      ensure  => present,
      before  => Package['sentry'],
      require => Class['base::yum'],
  }

  package {
    'sentry':
      ensure   => present,
      provider => pip;
  }
}
