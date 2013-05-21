# class sentry
class sentry {

  include sentry::user
  include base::yum

  package {
    [
      'python-devel',
      'python-eventlet',
      'python-redis',
    ]:
      ensure  => present,
      before  => Package['sentry'],
      require => Class['base::yum'],
  }

  package {
    'nydus':
      ensure   => present,
      provider => pip;
  }

  package {
    'sentry':
      ensure   => present,
      provider => pip;
  }
}
