# Monolith aggregator
define monolith::aggregator_settings(
    $subnet_id,
    $config_ini,
    $ga_auth,
    $mkt_auth,
    $solitude_aws_keys,
    $cluster='monolith.aggregator'
) {
    $site_name = $name

    $project_dir = "/data/${cluster}/www/${site_name}"
    $settings_dir = "${project_dir}/settings"

    file {
        "${project_dir}/fabfile.py":
            content => template('monolith/fabfile.aggregator.py');
    }

    file {
        $settings_dir:
            ensure => directory;

        "${settings_dir}/monolith.ini":
            content => $config_ini;

        "${settings_dir}/auth.json":
            content => $ga_auth;

        "${settings_dir}/monolith.password.ini":
            content => $mkt_auth;

        "${settings_dir}/solitude_aws_keys.ini":
            content => $solitude_aws_keys;
    }

    mozwebadmin::application {
        $site_name:
            project_dir => $project_dir,
            subnet_id   => $subnet_id,
            cluster     => $cluster;
    }
}
