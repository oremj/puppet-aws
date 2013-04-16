class audit {
    $all_uids = 'yes'

    include audit::aws

    service {
        'auditd':
            ensure    => running,
            enable    => true,
            require   => Package['audit_package'],
            hasstatus => true;
    }

    File {
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => Package['audit_package'],
        notify  => Service['auditd'],
    }

    file {
        '/etc/audit/auditd.conf':
            source => 'puppet:///modules/audit/auditd.conf';

        '/etc/audit/audit.rules':
            content => template('audit/audit.rules.erb');

        '/etc/audisp/audispd.conf':
            source => 'puppet:///modules/audit/audispd.conf';

        '/etc/audisp/plugins.d/syslog.conf':
            source  => 'puppet:///modules/audit/syslog.conf';
    }

    exec {
        'restart-auditd':
            path    => '/bin:/usr/bin:/sbin:/usr/sbin',
            command => '/etc/init.d/auditd restart',
            onlyif  => "auditctl -s | grep 'pid=0\\|enabled=0' || if [ $(pidof audisp-cef) ]; then false; else true; fi";
    }
}
