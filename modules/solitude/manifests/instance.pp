define solitude::instance(
    $project_dir,
    $app_name,
    $git_ref,
    $db_host,
    $db_name,
    $db_user,
    $db_password,
    $secret_key
) {
    $app_domain = $name
    solitude::checkout {
        $app_domain:
            ref => $git_ref,
            project_dir => $project_dir;
    }

    solitude::settings {
        $app_domain:
            require => Solitude::Checkout[$app_domain],
            project_dir => $project_dir,
            db_host => $db_host,
            db_name => $db_name,
            db_user => $db_user,
            db_password => $db_password,
            secret_key => $secret_key;
    }

    solitude::worker {
        $app_name:
            require => Solitude::Settings[$app_domain],
            project_dir => $project_dir;
    }

    solitude::nginx {
        $app_domain:
            require => Solitude::Worker[$app_name],
            gunicorn_name => "gunicorn-solitude-${app_name}";
    }

}
