# add an apache module

define apache::module() {
    include apache::module::dir
    file {
        "/etc/httpd/modules.d/${name}.conf":
            notify => Service[httpd],
            content => "LoadModule ${name}_module modules/mod_${name}.so\n";
    }
}
