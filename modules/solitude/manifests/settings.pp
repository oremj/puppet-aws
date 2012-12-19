define solitude::settings(
    $project_dir,
    $db_url,
    $secret_key,
) {

    file {
        "${project_dir}/solitude/solitude/settings/local.py":
            content => template('solitude/settings/local.py');
    }
}
