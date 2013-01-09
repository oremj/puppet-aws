class graphite::whisper::package (
  $version='0.9.10'
  ){

  $whisper_rpm = "whisper-${version}-1.noarch.rpm"

  file {
    "/var/tmp/${whisper_rpm}":
      ensure => present,
      source => "puppet:///modules/${module_name}/${whisper_rpm}",
  }

  package {
    'whisper':
      ensure   => present,
      provider => rpm,
      source   => "file:///var/tmp/${whisper_rpm}",
      require  => File["/var/tmp/${whisper_rpm}"],
  }

}
