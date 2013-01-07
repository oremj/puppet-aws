class puppet::config::master{

  file { '/usr/local/bin/update-repo':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/bin/update-repo";
  }

}
