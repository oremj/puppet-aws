class collectd {

  package {
      'collectd':
          ensure  => latest,
          require => Yumrepo['mozilla'];
  }

  service {
      'collectd':
          ensure  => running,
          require => Package['collectd'];
  }

}
