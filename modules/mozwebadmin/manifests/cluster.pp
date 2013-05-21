# mozwebadmin cluster
define mozwebadmin::cluster(
    $packr_port,
    $packr_alt_names = 'puppet localhost'
) {
    $cluster_name = $name

    app_packr::server {
        $cluster_name:
            port      => $packr_port,
            alt_names => $packr_alt_names;
    }

    app_packr::client {
        $cluster_name:
            pkghost => "http://localhost:${packr_port}";
    }

    file {
        [
          "/data/${cluster_name}",
          "/data/${cluster_name}/www"]:
            ensure => directory;
    }
}
