define pyrepo::package(
    $version
) {
    exec {
        "pyrepo-package-install-${name}":
            refreshonly => true,
            command => "/usr/bin/pip install --no-index -f ${pyrepo::server} ${name}==${version}";
    }
}
