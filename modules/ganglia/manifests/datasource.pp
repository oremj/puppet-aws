# ganglia datasource
define ganglia::datasource(
    $gmond_port,
    $include_gmond = true
) {
    $cluster = $name
    file {
        "/etc/ganglia/gmetad.d/${cluster}.conf":
            notify  => Service['gmetad'],
            content => "data_source \"${cluster}\" localhost:${gmond_port}\n";
    }

    if($include_gmond) {
        ganglia::listener {
            $cluster:
                before     => File["/etc/ganglia/gmetad.d/${cluster}.conf"],
                gmond_port => $gmond_port;
        }
    }
}
