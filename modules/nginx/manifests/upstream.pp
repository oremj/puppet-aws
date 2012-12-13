define nginx::upstream(
    $upstream_host,
    $upstream_port
) {
    $upstream_name = $name
    nginx::config {
        "upstream_${upstream_name}":
            content => "upstream ${upstream_name} { server ${upstream_host}:${upstream_port}; }\n";
    }
}
