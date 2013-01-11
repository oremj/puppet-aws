define xinetd::service(
    $content
){
    $service = $name
    file {
        "/etc/xinetd.d/${service}":
            notify => Service['xinetd'],
            content => $content;
    }
}
