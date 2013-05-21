# grahite packages class
class graphite::packages{
  realize (Yumrepo['epel'])
  # only needed because the rpms are local (for now)
  package {
    [
      'apr',
      'apr-util',
      'generic-logos',
      'pixman',
      'pycairo',
      'django-tagging',
      'Django',
      'httpd',
      'python-twisted-core',
      'mod_wsgi'
    ]:
      ensure => present,
      before => [
                  Package['carbon'],
                  Package['whisper'],
                  Package['graphite-web'],
      ],
  }

}

