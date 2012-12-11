define supervisord::program(
    $command,
    $cwd,
    $user,
    $environ = ''
) {
    $program_name = $name
    file {
        "/etc/supervisord.conf.d/$program_name.conf":
            notify => Service['supervisord'],
            content => templates('supervisord/program.conf');
    }
}
