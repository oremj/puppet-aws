define solitude::nginx(
    gunicorn_name 
) {
    $app_domain = $name

    nginx::config {
        "${app_domain}":
            content => template('solitude/nginx.conf') 
    }
    nginx::logdir {
        "${app_domain}":;
    }

}
