class sentry {

  include sentry::user
 
  package {
    'python-devel':
      ensure => present,
      before => Package['sentry']
  }

  package {
    'sentry':
      ensure   => present,
      provider => pip;
  }


}
