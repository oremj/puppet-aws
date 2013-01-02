define celery::service (
    $app_dir,
    $user = 'celery',
    $workers = '4',
    $python = '/usr/bin/python',
    $log_level = 'INFO',
    $args = ''
) {
    include supervisord

    if $user == 'celery' {
        include celery::user
    }

    $celery_name = $name

    supervisord::program {
        "celeryd-${celery_name}":
            command => "${python} ${project_dir} --loglevel=${log_level} -c ${workers} ${args}",
            app_dir => $app_dir,
            user    => $user;
    }

}
