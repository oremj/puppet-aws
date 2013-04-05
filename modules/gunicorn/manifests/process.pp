# Set up gunicorn process
define gunicorn::process(
    $gunicorn,
    $port,
    $wsgi_module,
    $cwd,
    $user,
    $addr = '127.0.0.1',
    $workers = '4',
    $max_requests = '5000',
    $log_syslog = false
) {
    $app_name = $name

    $log_syslog_arg = $log_syslog ? {
        true => '--log-syslog',
        false => '',
    }

    supervisord::program {
        "gunicorn-${app_name}":
            command => "${gunicorn} -b ${addr}:${port} -w ${workers} --max-requests ${max_requests} -n gunicorn-${app_name} ${log_syslog_arg} ${wsgi_module}",
            cwd     => $cwd,
            user    => 'nginx';
    }

}
