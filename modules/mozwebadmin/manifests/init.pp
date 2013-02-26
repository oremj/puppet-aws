class mozwebadmin {
    class {
        'pyrepo':
            server => 'https://pyrepo.addons.mozilla.org/';
    }

    package {
        'git':
            ensure => 'present';
    }

    file {
        ['/data',
         '/data/security_policies']:
            ensure => 'directory';

        '/data/fabfile.py':
            content => template('mozwebadmin/fabfile.py');
    }
}
