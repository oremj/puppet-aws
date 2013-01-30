define mozdeploy::server(
    $port = '80',
    $alt_names = ''
) {
    $cluster = $name
    $server_name = "${cluster}.mozdeploy"

    include mozdeploy
    include nginx
    nginx::config {
        $server_name:
            content => template('mozdeploy/server/nginx.conf');
    }

    nginx::logdir {
        $server_name:;
    }
}
