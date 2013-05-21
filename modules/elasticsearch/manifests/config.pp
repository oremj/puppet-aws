# elasticsearch config class
class elasticsearch::config(
  $cluster_name = undef,
  $aws_access_key = undef,
  $aws_secret_key = undef,
  $es_data_path = '/var/lib/elasticsearch',
  $aws_region = 'us-west-2',
  $expected_nodes = '3',
){

  $es_name = $ec2_instance_id
  # make sure atleast 1 thread
  $es_threads = (($::processorcount/2) + 1)
  $es_max_mem = inline_template('<%= @memorysize =~ /^(\d+)/; val = ( ( $1.to_i * 1024) / 1.50 ).to_i %>m')

  file {
    [
      '/var/log/elasticsearch',
      '/var/lib/elasticsearch',
      '/var/run/elasticsearch',
    ]:
      ensure  => directory,
      owner   => "${elasticsearch::user}",
      mode    => '0755',
  }

  file {
    '/etc/security/limits.d/90-elasticsearch.conf':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => "# THIS FILE MANAGED BY PUPPET.\n${elasticsearch::user} soft nofile 65535\n${elasticsearch::user} hard nofile 65535\n";
  }

  file {
    "${elasticsearch::config_dir}":
        ensure => directory,
        owner  => "${elasticsearch::user}";

    "${elasticsearch::config_dir}/elasticsearch.yml":
        ensure  => present,
        content => template('elasticsearch/elasticsearch.yml.erb'),
        owner   => "${elasticsearch::user}";

    "${elasticsearch::config_dir}/wordlist.txt":
        ensure  => present,
        content => template('elasticsearch/wordlist.txt'),
        owner   => "${elasticsearch::user}";

    "${elasticsearch::config_dir}/logging.yml":
        ensure  => present,
        content => template('elasticsearch/logging.yml.erb'),
        owner   => "${elasticsearch::user}";
  }

  file {
    '/etc/sysconfig/elasticsearch':
        ensure  => present,
        content => template('elasticsearch/sysconfig.erb')
  }

}
