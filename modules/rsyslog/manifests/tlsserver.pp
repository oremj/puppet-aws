class rsyslog::tlsserver(
    $ca_cert_content,
    $server_cert_content,
    $server_key_content,
    $ca_cert = '/etc/pki/rsyslog/rsyslog-ca.crt',
    $server_cert = '/etc/pki/rsyslog/rsyslog-ca.crt',
    $server_key = '/etc/pki/rsyslog/rsyslog-ca.crt'
) {
    rsyslog::config {
        'tlsserver':
            content => template('rsyslog/tlsserver.conf');
    }
    file {
        "${ca_cert}":
            ensure  => present,
            mode    => '0644',
            content => template("${ca_cert_content}"),
            before  => Rsyslog::Config['web'],
      }
    file {
        "${server_cert}":
            ensure  => present,
            mode    => '0644',
            content => template("${server_cert_content}"),
            before  => Rsyslog::Config['web'],
      }
    file {
        "${server_key}":
            ensure  => present,
            mode    => '0644',
            content => template("${server_key_content}"),
            before  => Rsyslog::Config['web'],
      }
}
