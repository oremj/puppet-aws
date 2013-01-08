class graphite::packages {

  package {
    [
      'Django14',
      'MySQL-python',
      'cairo',
      'django-tagging',
      'fontconfig',
      'pycairo',
      'python-memcache',
      'python-twisted',
      'python-txamqp',
      'zope-interface',
    ]:
      ensure => present,
      before => [
                  Package['carbon'],
                  Package['whisper'],
                  Package['graphite-web'],
      ],
  }

  package {
    [
      'carbon',
      'whisper',
      'graphite-web',
    ]:
      provider => pip;
  }

  # we need statsd
  nodejs::npm{
    'statsd':;
  }

}
