class nginx(
    $nx_user = 'nginx',
    $version = 'present'
){
    package {
        'nginx':
            ensure  => $version;
    }

    service {
        'nginx':
            require    => Package['nginx'],
            ensure     => running,
            enable     => true,
            restart    => '/etc/init.d/nginx restart'
            restart    => '/etc/init.d/nginx status'
            hasstatus  => true,
            hasrestart => true;
    }

    file {
        # the absence of 'source => ...' tells puppet that we want to remove all unmanaged files from these directories.
        # TODO: Fix bug 811515 someday, so that unmanaged directories are removed as well.
        ['/etc/nginx/',
         '/etc/nginx/conf.d/',
         '/etc/nginx/managed/']:
            notify  => Service['nginx'],
            ensure  => 'directory',
            force   => true,
            recurse => true,
            purge   => true;

        '/etc/nginx/nginx.conf':
            before  => Service[nginx],
            content => template('nginx/nginx.conf');

        '/etc/nginx/conf.d/managed.conf':
            before  => Service[nginx],
            content => "include managed/*.conf;\n";

        '/etc/nginx/mime.types':
            source => 'puppet:///modules/nginx/mime.types';

        '/etc/nginx/conf.d/hostname.conf':
            require => Package[nginx],
            before  => Service[nginx],
            content => "add_header X-Backend-Server ${fqdn};\n";

        '/etc/sysconfig/nginx':
            require => Package['nginx'],
            mode    => '0644',
            content => template('nginx/sysconfig/nginx');

        '/etc/logrotate.d/nginx':
            require => Package[nginx],
            owner   => $user,
            group   => root,
            mode    => '0644',
            content => template('nginx/logrotate.conf');

        '/etc/init.d/nginx':
            require => Package[nginx],
            before  => Service[nginx],
            owner   => root,
            group   => root,
            mode    => '0755',
            source  => 'puppet:///modules/nginx/etc-init.d/nginx';
    }
}
