define solitude::worker(
    $project_dir,
    $workers = 4,
    $settings_module = 'solitude.settings'
) {
    $app_name = $name
    supervisord::program {
        "gunicorn-solitude-${app_name}":
            command => "${project_dir}/venv/bin/gunicorn -w ${workers} --max-requests 5000 -n gunicorn-$app_name wsgi.playdoh:application",
            cwd => "${project_dir}/solitude",
            user => "nginx",
            environ => "DJANGO_SETTINGS_MODULE=${settings_module}";
    }
}
