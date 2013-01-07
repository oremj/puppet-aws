class puppet::config(
  $is_master = false
){

  if $is_master {
    include puppet::config::master
  }

  # define puppet configuration
  file{ '/etc/puppet/puppet.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      content => template("${module_name}/puppet.conf.erb");
  }

}
