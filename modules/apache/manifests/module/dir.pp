class apache::module::dir {
    file {
        "/etc/httpd/modules.d":
            ensure => directory,
            notify => Service[httpd],
            recurse => true;
    }

    file {
        "/etc/httpd/conf.d/modules_d.conf":
            notify => Service[httpd],
            content => "Include modules.d/*.conf\n";
    }
}
