class sentry::nginx {

    include nginx

    $app_domain = $sentry::service::url_prefix

    $app_name = 'sentry-http'

    nginx::upstream {
        "${app_name}":
            upstream_port => $sentry::service::web_port,
            require       => Class['nginx'];
    }

    nginx::logdir {
        "${app_domain}":;
            before       => Class['nginx'];
    }

    nginx::config {
        "${app_domain}":
            content => template('sentry/nginx.conf.erb'),
            require => Class['nginx'];
    }

}
