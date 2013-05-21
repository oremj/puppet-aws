# allowed hosts should just be a comma separated string
define rsyncd::module(
    $path,
    $allowed_hosts
) {
    $rsync_module_name = $name

    file {
        "/etc/rsyncd.conf.d/${rsync_module_name}.conf":
            notify  => Exec['build-rsync'],
            content => template('rsyncd/module.conf');
    }

}
