define solitude::nginx(
    $project_dir,
    $gunicorn_name 
) {
    $app_domain = $name

    nginx::config {
        "${app_domain}":
            content => template('solitude/nginx.conf');
        '00default':
            content => template('nginx/nginx.conf.default');
    }
    nginx::logdir {
        "${app_domain}":;
    }

}
