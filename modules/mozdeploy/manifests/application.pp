define mozdeploy::application(
    $build_command,
    $cluster
) {
    $app_name = $name
    file {
        "/data/${cluster}/build/${app_name}":
            require => Mozdeploy::server[$cluster],
            mode => '0700',
            content => template('mozdeploy/server/build_app.sh');
    }
}
