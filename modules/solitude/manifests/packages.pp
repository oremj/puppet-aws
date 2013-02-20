class solitude::packages {
    package {
        ['MySQL-python',
         'libxslt',
         'libxml2']:
            ensure => 'present';
    }
    package {
        'py-bcrypt':
          ensure  => present,
          require => Yumrepo['epel'];
    }
}
