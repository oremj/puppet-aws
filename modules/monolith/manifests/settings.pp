# Installs settings file for monolith.
define monolith::settings(
    $elasticsearch_hosts = 'localhost:9200',
    $statsd_host = 'localhost',
    $statsd_port = '8125',
    $statsd_rate = '1.0',
    $statsd_prefix = 'monolith.web',
    $settings_template = 'monolith/monolith.ini'
){
    $settings_dir = $name
    file {
        "${settings_dir}/monolith.ini":
            content => template($settings_template);
    }
}
