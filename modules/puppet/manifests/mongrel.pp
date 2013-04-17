# Sets up mongrel proxied through nginx
class puppet::mongrel(
    $listen_on = '8140',
    $mongrel_ports = ['18140',
                      '18141',
                      '18142',
                      '18143'],
    $cert_name = 'puppetmaster'
) {
    class {
        'nginx':
            nx_user => 'puppet';
    }

    nginx::config {
        'puppet.mongrel':
            content => template('puppet/mongrel.nginx.conf');
    }

    file {
        '/etc/sysconfig/puppetmaster':
            content => template('puppet/puppetmaster.sysconfig.mongrel');
    }

    package {
        'rubygem-mongrel':
            ensure => present;
    }
}
