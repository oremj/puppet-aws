# This assures that an app will be installed to the latest version on puppet runs.
define app_packr::install(
    $cluster,
    $version = 'LATEST'
) {
    $app_fqdn = $name
    exec {
        "app_packr-install-${app_fqdn}":
            require => App_packr::Client[$cluster],
            command => "/data/${cluster}/bin/install-app ${app_fqdn} ${version}";
    }
}
