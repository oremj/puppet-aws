class solitude::packages {
    package {
        ['MySQL-python',
         'libxslt',
         'libxml2']:
            ensure => 'present';
    }
}
