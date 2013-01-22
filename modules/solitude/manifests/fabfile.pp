define solitude::fabfile(
    $site,
    $lb_name,
    $subnet_id,
    $template = 'solitude/fabfile.py',
    $cluster => 'solitude' 
) {
    $project_dir = $name
    file {
        "${project_dir}/fabfile.py":
            content => template($template);
    }

    mozdeploy::application {
        $site:
            build_command => "${project_dir}/build %s %s %s",
            cluster => 'solitude.prod';
    }

}
