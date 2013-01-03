class sentry::user {
# Add a sentry user

  $default_user = 'sentry'

  user { $default_user:
      ensure  => present,
      uid     => '2001',
      gid     => $default_user,
      shell   => '/sbin/nologin',
      home    => "/home/${name}",
      require => Group[$default_user],
  }

  group { $default_user:
      ensure => present,
      gid    => '2001',
  }
}
