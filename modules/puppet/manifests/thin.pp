# Sets up thin proxied through nginx
class puppet::thin(
    $listen_on = '8140',
    $puppet_dir = '/etc/puppet/',
    $puppet_run_dir = '/var/run/puppet',
    $puppet_thin_port = '10000',
    $puppet_workers = '4',
    $puppet_rackup = '/usr/share/puppet/ext/rack/files/config.ru',
    $cert_name = 'puppetmaster'
) {
    class {
        'nginx':
            nx_user => 'puppet';
    }

    package {
        'rubygem-thin':
            ensure => present;
    }

    file {
        '/etc/init.d/puppetmaster':
            ensure  => present,
            content => template('puppet/init.d/puppetmaster'),
            mode    => '0755';
    }

    file {
        '/etc/puppetmaster.yml':
            ensure  => present,
            content => template('puppet/thin/puppetmaster.yml');
    }

    service {
        'puppetmaster':
            ensure  => running,
            enable  => true,
            require => [
                        File['/etc/init.d/puppetmaster'],
                        File['/etc/puppetmaster.yml'],
                        Package['rubygem-thin'],
            ],
    }

    nginx::config {
        'puppet.thin':
            content => template('puppet/thin.nginx.conf');
    }

}
