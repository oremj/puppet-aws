class sentry::nginx {

    include nginx

    $app_domain = $sentry::service::url_prefix
    nginx::upstream {
        "sentry-http":
            upstream_port => $sentry::service::web_port;
    }

    nginx::logdir {
        "${app_domain}":;
    }

    nginx::config {
        "${app_domain}":
            content => template('sentry/nginx.conf.erb'),
    }

}
