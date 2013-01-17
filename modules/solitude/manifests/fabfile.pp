define solitude::fabfile(
    $site,
    $lb_name,
    $subnet_id,
    $template = 'solitude/fabfile.py'
) {
    $project_dir = $name
    file {
        "${project_dir}/fabfile.py":
            content => template($template);
    }

}
