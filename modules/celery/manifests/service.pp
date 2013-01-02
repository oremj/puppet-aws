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
            command => "${python} ${app_dir}/manage.py celeryd --loglevel=${log_level} -c ${workers} ${args}",
            cwd     => $app_dir,
            user    => $user;
    }

}
