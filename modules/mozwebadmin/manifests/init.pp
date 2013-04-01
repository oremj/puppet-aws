# Base class for webadmin servers.
class mozwebadmin {
    class {
        'pyrepo':
            server => 'https://pyrepo.addons.mozilla.org/';
    }

    package {
        [
            'gcc',
            'git',
            'libxml2-devel',
            'libxslt-devel',
            'mysql',
            'puppet',
            'puppet-server',
            'python-crypto',
            'python-devel'
        ]:
            ensure => 'present';
    }

    file {
        ['/data', '/data/security_policies']:
            ensure => 'directory';

        '/data/fabfile.py':
            content => template('mozwebadmin/fabfile.py');
    }
}
