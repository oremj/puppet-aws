class audit::aws {
    package {
        'audit_package':
            ensure => latest,
            name   => 'audit-mozilla';
        'audispd-mozilla-plugins':
            ensure => latest;
        'audit-mozilla-libs-python':
            ensure => latest;
        'audit-mozilla-libs':
            ensure => latest,
            before => Package['audit_package'];

        'audit':
            ensure => absent,
            before => Package['audit_package'];
        'audispd-plugins':
            ensure => absent,
            before => Package['audispd-mozilla-plugins'];
        'audit-libs-python':
            ensure => absent;
        'audit-libs':
            ensure => latest,
            before => Package['audit-libs'];
        'audit-libs-2.2-2.17.amzn1.i686':
            ensure => absent,
            before => [Package['audit-mozilla-libs'], Package['audit_package']];
        'pam-1.1.1-10.19.amzn1.i686':
            ensure => absent,
            before => [Package['audit-mozilla-libs'], Package['audit_package']];
        'audispd-plugins-1.8-3.el5.centosmoz5.i386':
            ensure => absent;
    }
}
