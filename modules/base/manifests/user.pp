# base user
define base::user(
  $uid = undef
){

  $default_user = $name

  user { $default_user:
      ensure  => present,
      uid     => $uid,
      gid     => $default_user,
      shell   => '/sbin/nologin',
      home    => "/home/${default_user}",
      require => Group[$default_user],
  }

  group { $default_user:
      ensure => present,
      gid    => $uid
  }
}
