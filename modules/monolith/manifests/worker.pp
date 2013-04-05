# Defines gunicorn worker.
define monolith::worker(
    $project_dir,
    $wsgi_module = 'runserver:application',
    $port = '10000',
    $workers = 4,
) {
    $app_name = $name
    gunicorn::process {
        "monolith-${app_name}":
            gunicorn     => "${project_dir}/venv/bin/gunicorn",
            port         => $port,
            wsgi_module  => $wsgi_module,
            workers      => $workers,
            user         => 'nginx',
            cwd          => "${project_dir}/monolith";
    }

    nginx::upstream {
        "gunicorn-monolith-${app_name}":
            upstream_port => $port,
    }
}
