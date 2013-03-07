define solitude::nginx(
    $project_dir,
    $gunicorn_name 
) {
    $app_domain = $name

    nginx::config {
        "${app_domain}":
            content => template('solitude/nginx.conf');
    }

    nginx::default_server_block {
        "${app_domain}":
            content => template('solitude/healthcheck.nginx.conf');
    }

    nginx::logdir {
        "${app_domain}":;
    }

}
