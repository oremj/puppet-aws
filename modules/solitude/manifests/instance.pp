define solitude::instance(
    $project_dir,
    $app_name
) {
    include solitude::packages

    $app_domain = $name

    solitude::worker {
        $app_name:
            project_dir => $project_dir;
    }

    solitude::nginx {
        $app_domain:
            require => Solitude::Worker[$app_name],
            gunicorn_name => "gunicorn-solitude-${app_name}";
    }

}
