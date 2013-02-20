class audit::aws {
    # remove these before we even start.
    package {
      [
        'audit',
        'audispd-plugins',
        'audit-libs-python',
        'audit-libs-2.2-2.17.amzn1.i686',
        'pam-1.1.1-10.19.amzn1.i686',
      ]:
            ensure => absent,
            before => [ 
                        Package['audispd-mozilla-plugins'],
                        Package['audit-mozilla'],
                        Package['audit-mozilla-libs'],
                        Package['audit-mozilla-libs-python'],
            ];
    }

    package {
        'audit-mozilla':
            ensure => latest;
        'audispd-mozilla-plugins':
            ensure => latest;
        'audit-mozilla-libs-python':
            ensure => latest;
        'audit-mozilla-libs':
            ensure => latest,
            before => Package['audit-mozilla'];
        'audit-libs':
            ensure => latest;
    }
}
