define mozdeploy::client(
    $pkghost
) {
    $cluster = $name
    file {
        "/data/${cluster}/bin/install-app":
            mode => 0700,
            content => template('mozdeploy/client/install-app');
    }
}
