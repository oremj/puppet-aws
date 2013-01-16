class mozwebnode{
    include supervisord

    package {
        'git':
            ensure => 'present';
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
