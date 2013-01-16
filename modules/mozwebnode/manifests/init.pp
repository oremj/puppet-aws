class mozwebnode(
    $syslog_servers,
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

}
