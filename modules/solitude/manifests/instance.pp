# solitude instance
define solitude::instance(
    $project_dir,
    $app_name,
    $wsgi_module = 'wsgi.playdoh:application'
) {
    include solitude::packages

    $app_domain = $name

    solitude::worker {
        $app_name:
            project_dir => $project_dir,
            wsgi_module => $wsgi_module;
    }

    solitude::nginx {
        $app_domain:
            require       => Solitude::Worker[$app_name],
            project_dir   => $project_dir,
            gunicorn_name => "gunicorn-solitude-${app_name}";
    }

}
