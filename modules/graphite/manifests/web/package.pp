# Class: graphite
#
# This module manages graphite
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class graphite::web::package (
    $version='0.9.10'
){
  $graphite_rpm = "graphite-web-${version}-3.noarch.rpm"

  file {
    "/var/tmp/${graphite_rpm}":
      ensure => present,
      source => "puppet:///modules/${module_name}/${graphite_rpm}",
  }

  package {
    # 'bitmap-fonts-compat':
    #   ensure => present;
    'graphite-web':
      ensure   => present,
      provider => rpm,
      source   => "file:///var/tmp/${graphite_rpm}",
      require  => File["/var/tmp/${graphite_rpm}"],
  }

}
