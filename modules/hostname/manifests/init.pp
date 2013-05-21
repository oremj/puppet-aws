# hostname class
class hostname(
    $hostname = 'nohostname',
) {
    exec {
        "/bin/hostname ${hostname}":
            unless => "/usr/bin/test \"$(/bin/hostname)\" = \"${hostname}\"";
    }

    file {
        '/etc/sysconfig/network':
            ensure  => present,
            content => template('hostname/network.erb');
    }
}
