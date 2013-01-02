define rsyslog::config(
    $content
) {
    $config_name = $name
    file {
        "/etc/rsyslog.d/${config_name}.conf":
            notify => Service['rsyslog'],
            content => $content;
    }
}
