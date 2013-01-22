define mozdeploy::server(
    $hostroot,
    $builddir = '/data/.mozdeploybuild',
    $port = '80',
    $alt_names = ''
) {
    $cluster = $name
    $server_name = "${cluster}.mozdeploy"

    include nginx
    nginx::config {
        $server_name:
            content => template('mozdeploy/server/nginx.conf');
    }

    nginx::logdir {
        $server_name:;
    }

    file {
        "/data/${cluster}/mozdeploy.cfg":
            mode => '0600',
            content => template('mozdeploy/server/mozdeploy.cfg');

        "/data/${cluster}/build":
            ensure => directory,
            purge => true,
            recurse => true;
    }
}
