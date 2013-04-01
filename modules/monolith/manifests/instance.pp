# Define instance of monolith on web node.
define monolith::instance(
    $project_dir,
    $app_name,
    $wsgi_module = 'runserver:application'
) {
    include monolith::packages

    $app_domain = $name

    monolith::worker {
        $app_name:
            project_dir => $project_dir,
            wsgi_module => $wsgi_module;
    }

    monolith::nginx {
        $app_domain:
            require       => Monolith::Worker[$app_name],
            project_dir   => $project_dir,
            gunicorn_name => "gunicorn-monolith-${app_name}";
    }
}
