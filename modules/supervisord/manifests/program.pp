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
    }

    service {
        "supervisord-${program_name}":
            ensure  => 'running',
            enabe   => true,
            restart => "/usr/bin/supervisorctl restart ${program_name}",
            start   => "/usr/bin/supervisorctl start ${program_name}",
            stop    => "/usr/bin/supervisorctl stop ${program_name}",
            status  => "/usr/bin/supervisorctl status ${program_name} | /bin/grep -q RUNNING",
            require => Service['supervisord'];
    }
}
