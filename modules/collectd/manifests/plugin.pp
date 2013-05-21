# collectd plugin
define collectd::plugin(
  $package = false,
  $collectd_args = undef
){
  include collectd

  $include_dir = '/etc/collectd.d'

  if $package {
      package {
        "collectd-${name}":
            ensure => latest;
      }
  }

  $collectd_require = $package ? {
      true    => [Package["collectd-${name}"]],
      default => [],
  }

  file {
    "${include_dir}/${name}.conf":
        ensure      => present,
        content     => template("collectd/collectd.d/${name}.conf.erb"),
        notify      => Service['collectd'],
        require     => $collectd_require,
  }

}
