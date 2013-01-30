define mozdeploy::application(
    $project_dir,
    $build_command,
    $cluster
) {
    $app_name = $name
    file {
        "${project_dir}/mozdeploy.json":
            require => Mozdeploy::Server[$cluster],
            mode => '0700',
            content => template('mozdeploy/server/mozdeploy.json');
    }
}
