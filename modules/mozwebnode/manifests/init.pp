class mozwebnode(
    $syslog_servers,
    $rsyslog_ca_cert_content,
    $rsyslog_ca_cert = '/etc/pki/rsyslog/rsyslog-ca.crt',
    $tls = true
){
    include supervisord
    include rsyslog

    package {
        'git':
            ensure => 'present';
    }

    rsyslog::config {
        'web':
            content => template('mozwebnode/syslog.conf');
    }

    class {
        'nginx':
            version => 'present';
    }

    file {
        '/data':
            ensure => 'directory';
    }

    # install ca cert
    if $tls {
      file {
        "${rsyslog_ca_cert}":
          ensure  => present,
          mode    => '0644',
          content => template("${rsyslog_ca_cert_content}"),
          before  => Rsyslog::Config['web'],
      }
    }

}
