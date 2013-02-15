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
        '/data':
            ensure => 'directory';

        '/data/fabfile.py':
            content => 'from mozawsdeploy.fabfile.aws import *';
    }
}
