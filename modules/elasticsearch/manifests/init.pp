# elasticsearch class
class elasticsearch (
    $version = '0.20.5-1.amzn1',
    $package = 'elasticsearch',
    $java_package = 'java-1.7.0-openjdk',
    $config_dir = '/etc/elasticsearch',
    $user = elasticsearch,
    $plugins = ['elasticsearch-plugin-cloud-aws']
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
