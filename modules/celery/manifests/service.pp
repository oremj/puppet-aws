define celery::service (
    $project_dir,
    $user = 'celery',
    $workers = '4',
    $python = '/usr/bin/python',
    $loglevel = 'INFO',
    $args = ''
) {
    include supervisord

    if $user == 'celery' {
        include celery::user
    }

    $celery_name = $name

    supervisord::program {
        "celeryd-${celery_name}":
            command => "${python} ${project_dir} --loglevel=${loglevel} -c ${workers} ${args}",
            app_dir => $app_dir,
            user    => $user;
    }

}
