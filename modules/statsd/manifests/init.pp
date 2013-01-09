class statsd (
  $version='0.5.0-1'
){

  $user = 'statsd'
  $statsd_rpm = "nodejs-statsd-${version}.amzn1.x86_64.rpm"
  file {
    "/var/tmp/${statsd_rpm}":
      ensure => present,
      source   => "puppet:///modules/${module_name}/${statsd_rpm}",
  }

  package {
    'statsd':
      provider => rpm,
      ensure   => present,
      source   => "file:///var/tmp/${statsd_rpm}",
      require  => File["/var/tmp/${statsd_rpm}"],
  }

  base::user{
    "${user}":
      uid => '2002'
  }
}
