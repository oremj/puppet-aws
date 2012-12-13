define solitude::settings(
    $project_dir,
    $db_host,
    $db_name,
    $db_user,
    $db_password,
    $secret_key,
    $db_port = '3306',
) {

    file {
        "${project_dir}/solitude/settings/local.py":
            content => template('solitude/settings/local.py');
    }
    

}
