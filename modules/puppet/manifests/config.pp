class puppet::config(
  $is_master = false
){

  # define puppet configuration
  file{ '/etc/puppet/puppet.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      content => template("${module_name}/puppet.conf.erb");
  }
}
