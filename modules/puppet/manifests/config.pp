# defines /etc/puppet.conf
class puppet::config(
  $puppet_server = 'puppet',
  $is_master = false,
  $altnames = []
){

  # include puppet packages
  include puppet::packages

  if $is_master {
    include puppet::config::master
  }

  # define puppet configuration
  file{ '/etc/puppet/puppet.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      content => template("${module_name}/puppet.conf.erb"),
      before  => Class['puppet::packages'],
  }

}
