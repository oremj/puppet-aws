class mozwebnode(
    $cluster,
    $pkghost
){
    include supervisord

    package {
        'git':
            ensure => 'present';
    }

    class {
        'nginx':
            version => 'present';
    }

    file {
        ['/data',
         "/data/${cluster}",
         "/data/${cluster}/bin"]:
            ensure => 'directory';
    }

    mozdeploy::client {
        $cluster: 
            pkghost => $pkghost;
    }
}
