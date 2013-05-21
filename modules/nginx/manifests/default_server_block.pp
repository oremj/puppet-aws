# nginx default server block
define nginx::default_server_block(
    $content
) {
    $conf_name = $name
    nginx::config {
        "${conf_name}_default":
            content => $content,
            suffix  => '.default';
    }
}
