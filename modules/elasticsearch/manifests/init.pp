class elasticsearch (
    $version = '0.20.5-1.amzn1',
    $package = 'elasticsearch',
    $java_package = 'java-1.7.0-openjdk',
    $config_dir = '/etc/elasticsearch',
    $user = elasticsearch,
    $plugins = false
){

  include elasticsearch::user

  package {
    $package:
        ensure  => $version,
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

  service { 'elasticsearch':
      ensure  => running,
      enable  => true,
      require => Package[$package];
  }

  if $plugins {
      class {
          'elasticsearch::plugins':
              require => Package[$package]; 
      }
  }
}
