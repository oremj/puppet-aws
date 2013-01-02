class mozwebnode(
    $syslog_server
){
    include supervisord
    include rsyslog

    package {
        'git':
            ensure => 'present';
    }

    class {
        'nginx':
            version => 'present';
    }

    file {
        ['/data',
         '/data/www']:
            ensure => 'directory';
    }

}
