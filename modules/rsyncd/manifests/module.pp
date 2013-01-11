# allowed hosts should just be a comma separated string
define rsyncd::module(
    $path,
    $allowed_hosts
) {
    $module_name = $name

    file {
        "/etc/rsyncd.conf.d/${module_name}.conf":
            notify => Exec['build-rsync'],
            content => template('rsyncd/module.conf');
    }

}
