class elasticsearch::config(
  $cluster_name,
  $aws_access_key,
  $aws_secret_key,
  $aws_region = 'us-west-2',
  $expected_nodes = '3',
){

  $es_name = $ec2_instance_id
  # make sure atleast 1 thread
  $es_threads = (($::processorcount/2) + 1)
  $es_max_mem = inline_template('<%= @memorysize =~ /^(\d+)/; val = ( ( $1.to_i * 1024) / 1.50 ).to_i %>m')

  file {
    "${elasticsearch::config_dir}/elasticsearch.yml":
        ensure  => present,
        content => template('elasticsearch/elasticsearch.yml.erb'),
        owner   => "${elasticsearch::user}",
        require => Package['elasticsearch'];
  }
  file {
    "${elasticsearch::config_dir}/wordlist.txt":
        ensure  => present,
        content => template('elasticsearch/wordlist.txt'),
        owner   => "${elasticsearch::user}",
        require => Package['elasticsearch'];
  }
  file {
    "${elasticsearch::config_dir}/logging.yml":
        ensure  => present,
        content => template('elasticsearch/logging.yml.erb'),
        owner   => "${elasticsearch::user}",
        require => Package['elasticsearch'];
  }
  file {
    "/etc/sysconfig/elasticsearch":
        ensure  => present,
        content => template('elasticsearch/sysconfig.erb')
  }

}
