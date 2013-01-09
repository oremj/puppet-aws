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
class graphite::carbon::package (
    $version='0.9.10'
    ){

  $carbon_rpm = "carbon-${version}-1.noarch.rpm"

  file {
    "/var/tmp/${carbon_rpm}":
      ensure => present,
      source => "puppet:///modules/${module_name}/${carbon_rpm}",
  }

  package { 'carbon':
      ensure   => present,
      provider => rpm,
      source   => "file:///var/tmp/${carbon_rpm}",
      require  => File["/var/tmp/${carbon_rpm}"],
  }

}
