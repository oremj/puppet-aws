# Installs settings file for monolith.
define monolith::settings(
    $lb_name,
    $subnet_id,
    $instance_type = 'm1.small',
    $cluster = 'monolith',
    $elasticsearch_hosts = 'localhost:9200',
    $statsd_host = 'localhost',
    $statsd_port = '8125',
    $statsd_rate = '1.0',
    $statsd_prefix = 'monolith.web',
    $settings_template = 'monolith/monolith.ini'
){
    $site_name = $name
    $project_dir = "/data/${cluster}/www/${site_name}"
    $settings_dir = "${project_dir}/settings"

    file {
        "${project_dir}/fabfile.py":
            content => template('monolith/fabfile.py');
    }

    file {
        "${settings_dir}/monolith.ini":
            content => template($settings_template);
    }

    mozwebadmin::application {
        $site_name:
            project_dir   => $project_dir,
            lb_name       => $lb_name,
            subnet_id     => $subnet_id,
            cluster       => $cluster,
            instance_type => $instance_type;
    }
}
