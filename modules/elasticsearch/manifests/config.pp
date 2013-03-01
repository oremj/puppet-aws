class elasticsearch::config(
  $cluster_name,
  $unicast_hosts,
  $datacenter = 'aws'
){

  include elasticsearch

  $es_name = $ec2_instance_id
  $es_threads = $::processorcount/2
  $es_max_mem = inline_template('<%= @memorysize =~ /^(\d+)/; val = ( ( $1.to_i * 1024) / 1.50 ).to_i %>m')

  file {
    "${elasticsearch::config_dir}/elasticsearch.yml":
        ensure   => present,
        content  => template('elasticsearch/elasticsearch.yml.erb'),
        owner    => "${elasticsearch::user}",
        require  => Class['elasticsearch'];
  }
  file {
    "${elasticsearch::config_dir}/wordlist.txt":
        ensure   => present,
        content  => template('elasticsearch/wordlist.txt'),
        owner    => "${elasticsearch::user}",
        require  => Class['elasticsearch'];
  }
  file {
    "${elasticsearch::config_dir}/logging.yml":
        ensure   => present,
        content  => template('elasticsearch/logging.yml'),
        owner    => "${elasticsearch::user}",
        require  => Class['elasticsearch'];
  }
  file {
    "/etc/sysconfig/elasticsearch":
        ensure  => present,
        content => template('elasticsearch/sysconfig.erb')
  }

}
