class collectd {

  package {
      'collectd':
          ensure  => latest,
          require => Yumrepo['mozilla'];
  }

  service {
      'collectd':
          ensure  => running,
          enable  => true,
          require => Package['collectd'];
  }

}
