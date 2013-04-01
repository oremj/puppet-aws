# Define an application on the admin server.
define mozwebadmin::application(
    $project_dir,
    $lb_name,
    $subnet_id,
    $cluster,
    $instance_type = 'm1.small'
) {
    $site_name = $name

    file {
        $project_dir:
            ensure => directory;
        "${project_dir}/fabconfig.py":
            content => template('mozwebadmin/fabconfig.py');
    }

    app_packr::application {
        $site_name:
            project_dir   => $project_dir,
            build_command => "/usr/bin/fab -f ${project_dir}/fabfile.py build:{version},{build_id},{build_dir}",
            cluster       => $cluster,
            require       => File["${project_dir}/fabconfig.py",
                                    "${project_dir}/fabfile.py"];
    }
}
