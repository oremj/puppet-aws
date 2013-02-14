define app_packr::application(
    $project_dir,
    $build_command,
    $cluster
) {
    $app_name = $name
    file {
        "${project_dir}/app-packr.json":
            require => App_packr::Server[$cluster],
            mode => '0700',
            content => template('app_packr/server/app-packr.json');
    }
}
