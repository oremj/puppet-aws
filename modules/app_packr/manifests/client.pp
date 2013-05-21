# app_packr client
define app_packr::client(
    $pkghost
) {

    $cluster = $name
    $pkgroot = "${pkghost}/${cluster}"

    include app_packr
    file {
        "/data/${cluster}/bin/install-app":
            mode    => '0700',
            content => template('app_packr/client/install-app');
    }
}
