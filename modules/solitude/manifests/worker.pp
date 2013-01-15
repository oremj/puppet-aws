define solitude::worker(
    $project_dir,
    $port = '10000',
    $workers = 4,
    $settings_module = 'solitude.settings',
    $wsgi_module = 'wsgi.playdoh:application'
) {
    $app_name = $name
    supervisord::program {
        "gunicorn-solitude-${app_name}":
            command => "${project_dir}/venv/bin/gunicorn -b 127.0.0.1:$port -w ${workers} --max-requests 5000 -n gunicorn-$app_name ${wsgi_module}",
            cwd => "${project_dir}/solitude",
            user => "nginx",
            environ => "DJANGO_SETTINGS_MODULE=${settings_module}";
    }

    nginx::upstream {
        "gunicorn-solitude-${app_name}":
            upstream_port => $port,
    }
}
