class rsyncd(
    $rsync_user = 'nobody',
    $rsync_group = 'nobody'
){
    
    include xinetd 
    xinetd::service {
        'rsyncd':
            content => template('rsyncd/xinetd.conf');
    }

    file {
        '/etc/rsyncd.conf.d':
            ensure => directory,
            purge => true,
            recurse => true;

        '/etc/rsyncd.conf.d/00global.conf':
            notify => Exec['build-rsync'],
            content => template('rsyncd/global.conf');
    }

    exec {
        'build-rsync':
            command => 'cat /etc/rsyncd.conf.d/* > /etc/rsyncd.conf.new; mv /etc/rsyncd.conf.new /etc/rsyncd.conf',
            require => File['/etc/rsyncd.conf.d'],
            notify => Service['xinetd'],
            refreshonly => true;
    }
}
