# puppet packages class
class puppet::packages(
    $puppet_version = '3.1.1-1.el6',
    $facter_version = '1.7.0-2.el6'
){
    include base::yum
    realize (Yumrepo['puppetlabs-products'])
    realize (Yumrepo['puppetlabs-deps'])
    realize (Yumrepo['mozilla'])

    package {
        'puppet':
            ensure  => $puppet_version,
            require => [
                          Package['facter'],
                          Yumrepo['puppetlabs-products'],
                          Yumrepo['puppetlabs-deps'],
            ]
    }
    package {
        'facter':
            ensure  => $facter_version,
            require => Yumrepo['mozilla'],
    }

}
