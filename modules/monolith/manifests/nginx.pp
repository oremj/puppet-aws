# nginx config for monolith
define monolith::nginx(
    $project_dir,
    $gunicorn_name
) {
    $app_domain = $name

    nginx::config {
        $app_domain:
            content => template('monolith/nginx.conf');
    }

    nginx::default_server_block {
        $app_domain:
            content => template('monolith/healthcheck.nginx.conf');
    }

    nginx::logdir {
        $app_domain:;
    }

}
