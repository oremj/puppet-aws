define ganglia::listener(
    $gmond_port
) {
    $cluster = $name
    file {
        "/etc/ganglia/gmond.d/${cluster}.conf":
            notify => Service["supervisord-gmond-${cluster}"],
            content => template('ganglia/gmond.datasource.conf');
    }

    supervisord::program {
        "gmond-${cluster}":
            command => "/usr/sbin/gmond -f -c /etc/ganglia/gmond.d/${cluster}.conf",
            cwd => '/tmp',
            user => 'ganglia',
            require => [File["/etc/ganglia/gmond.d/${cluster}.conf"], Package['ganglia-gmond']];
    }
}
