class hostname(
    $hostname
) {
    exec {
        "/bin/hostname ${hostname}":
            unless => "/usr/bin/test \"$(/bin/hostname)\" = \"${hostname}\"";
    }
}
