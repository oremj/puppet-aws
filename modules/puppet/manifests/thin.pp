# Sets up thin proxied through nginx
class puppet::thin(
    $listen_on = '8140',
    $puppet_dir = '/etc/puppet/',
    $puppet_socket_dir = '/var/run/puppet/',
    $puppet_workers = '4',
    $puppet_pid = '/var/run/puppet/puppetmasterd.pid',
    $puppet_rack_config = '/usr/share/puppet/ext/rack/files/config.ru',
    $cert_name = 'puppetmaster'
) {
    include supervisord
    class {
        'nginx':
            nx_user => 'puppet';
    }

    $thin = '/usr/bin/thin'


    supervisord::program {
      'puppetmaster':
        command => "${thin} start -P ${puppet_pid} -e production --servers ${puppet_workers} --daemonize --socket ${puppet_socket_dir}/puppetmasterd.sock --chdir ${puppet_dir}  --user puppet --group puppet -R ${puppet_rack_config}",
        cwd     => '/usr/bin',
        user    => 'puppet',
        require => [
                    Package['rubygem-thin'],
        ],
    }
    nginx::config {
        'puppet.thin':
            content => template('puppet/thin.nginx.conf');
    }

    package {
        'rubygem-thin':
            ensure => present;
    }
}
