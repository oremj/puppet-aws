# app_packr server
define app_packr::server(
    $port = '80',
    $alt_names = ''
) {
    $cluster = $name
    $server_name = "${cluster}.app_packr"

    include app_packr
    include nginx
    nginx::config {
        $server_name:
            content => template('app_packr/server/nginx.conf');
    }

    nginx::logdir {
        $server_name:;
    }
}
