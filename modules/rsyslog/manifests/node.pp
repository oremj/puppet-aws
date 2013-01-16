class rsyslog::node (
    $syslog_servers,
    $rsyslog_ca_cert_content,
    $rsyslog_ca_cert = '/etc/pki/rsyslog/rsyslog-ca.crt',
    $tls = true
){
    include rsyslog

    rsyslog::config {
        'node':
            content => template('rsyslog/syslog.conf');
    }

    # install ca cert
    if $tls {
      file {
        "${rsyslog_ca_cert}":
          ensure  => present,
          mode    => '0644',
          content => template("${rsyslog_ca_cert_content}"),
          before  => Rsyslog::Config['node'],
      }
    }

}
