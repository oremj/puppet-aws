class nodejs (
  $version='0.8.16'
){

  $node_rpm = "nodejs-${version}-1.x86_64.rpm"
  file {
    "/var/tmp/${node_rpm}":
      ensure => present,
      source   => "puppet:///modules/${module_name}/${node_rpm}",
  }

  package {
    'nodejs':
      provider => rpm,
      ensure   => present,
      source   => "file:///var/tmp/${node_rpm}",
  }

}
