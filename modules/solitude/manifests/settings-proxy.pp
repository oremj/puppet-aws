define solitude::settings-proxy(
    $project_dir,
    $site,
    $subnet_id,
    $secret_key,
    $server_email,
    $email_host,
    $cache_prefix,
    $sentry_dsn,
    $bango_auth,
    $paypal_app_id,
    $paypal_auth_user,
    $paypal_auth_password,
    $paypal_auth_signature,
    $paypal_chains,
    $statsd_host,
    $statsd_port,
    $lb_name = 'solitude-proxy-prod'
) {

    $web_server_type = 'web-proxy'

    file {
        [$project_dir,
         "${project_dir}/settings",
         "${project_dir}/settings/sites",
         "${project_dir}/settings/sites/${site}"]:
            ensure => 'directory';

        "${project_dir}/fabfile.py":
            content => template('solitude/fabfile-proxy.py');

        "${project_dir}/settings/local.py":
            content => template('solitude/settings/local_proxy.py');

        "${project_dir}/settings/sites/${site}/private_base.py":
            content => template('solitude/settings/private_proxy.py');
    }
}
