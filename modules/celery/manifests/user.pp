class celery::user {
# Add a default celery user if one is not defined

  $default_user = celery

  user { $default_user:
      ensure  => present,
      uid     => '2000',
      gid     => $default_user,
      shell   => '/sbin/nologin',
      home    => $celery::service::project_dir,
      require => Group[$default_user],
  }

  group { $default_user:
      ensure => present,
      gid    => '2000',
  }
}
