define supervisord::program(
    $command,
    $cwd,
    $user,
    $environ = ''
) {
    $program_name = $name
    file {
        "/etc/supervisord.conf.d/${program_name}.conf":
            notify => Service['supervisord'],
            content => template('supervisord/program.conf');

        "/etc/init.d/${name}":
            mode => '0755',
            content => template('supervisord/supervisor.erb');
    }

    service {
        "${program_name}":
            enable     => true,
            ensure     => running,
            hasrestart => true,
            hasstatus  => true,
            status     => "/sbin/service ${program_name} status",
            require    => File["/etc/init.d/${program_name}", "/etc/supervisord.conf.d/${program_name}.conf"];
    }
}
