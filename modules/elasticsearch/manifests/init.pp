class elasticsearch (
    $version,
    $plugins,
    $package = 'elasticsearch',
    $java_package = 'java-1.7.0-openjdk',
    $config_dir = '/etc/elasticsearch',
    $user = elasticsearch
){

  include elasticsearch::user

  package {
    $package:
        ensure  => present,
        version => $version,
        require => [
                   Yumrepo['mozilla'], 
                   Class['elasticsearch::user']
                   ];
  }
  package {
    $java_package:
        ensure => present,
        before => Package[$package];
  }

  file {
    [
      '/var/log/elasticsearch',
      '/var/lib/elasticsearch',
      '/var/run/elasticsearch',
      "${config_dir}/templates",
    ]:
      ensure  => directory,
      owner   => $user,
      mode    => '0755',
      require => Package[$package];
  }

  file { '/etc/security/limits.d/90-elasticsearch.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "# THIS FILE MANAGED BY PUPPET.\n${user} soft nofile 65535\n${user} hard nofile 65535\n",
      require => Package[$package];
  }

  if $plugins {
      class {
          'elasticsearch::plugins':
              require => Package[$package]; 
      }
  }
}
