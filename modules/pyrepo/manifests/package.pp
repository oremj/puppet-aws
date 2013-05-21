# pyrepo package class
define pyrepo::package(
    $version
) {
    exec {
        "pyrepo-package-install-${name}":
            unless  => "/usr/bin/pip freeze | grep -q \"${name}==${version}\"",
            command => "/usr/bin/pip install --no-index -f ${pyrepo::server} ${name}==${version}";
    }
}
