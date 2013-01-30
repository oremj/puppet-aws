define solitude::fabfile(
    $site,
    $site_name,
    $lb_name,
    $subnet_id,
    $template = 'solitude/fabfile.py',
    $cluster = 'solitude'
) {
    $project_dir = $name
    file {
        "${project_dir}/fabfile.py":
            content => template($template);
    }

    mozdeploy::application {
        $site_name:
            project_dir => $project_dir,
            build_command => "/usr/bin/fab -f ${project_dir}/fabfile.py build_release:{version},{build_id},{build_dir}",
            cluster => $cluster;
    }

}
