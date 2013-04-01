# Defines gunicorn worker.
define monolith::worker(
    $project_dir,
    $wsgi_module = 'runserver:application',
    $port = '10000',
    $workers = 4,
) {
    $app_name = $name
    supervisord::program {
        "gunicorn-monolith-${app_name}":
            command => "${project_dir}/venv/bin/gunicorn -b 127.0.0.1:${port} -w ${workers} --max-requests 5000 -n gunicorn-${app_name} ${wsgi_module}",
            cwd     => "${project_dir}/monolith",
            user    => 'nginx';
    }

    nginx::upstream {
        "gunicorn-monolith-${app_name}":
            upstream_port => $port,
    }
}
