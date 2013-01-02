define celery::service {
    $project_dir,
    $user = 'celery'.
    $workers = '4',
    $python = '/usr/bin/python',
    $loglevel = 'INFO'
    $args = ''

) {

    $celery_name = $name

    if $user == 'celery' {
        include celery::user
    }

    supervisord::program {
        "celeryd-${celery_name}":
            command => "${python} ${project_dir} --loglevel=${loglevel} -c ${workers} ${args}",
            app_dir => $app_dir,
            user    => $user;
    }

}
