define solitude::settings(
    $project_dir,
    $site,
    $subnet_id,
    $db_url,
    $db_url_slave,
    $secret_key,
    $server_email,
    $email_host,
    $memcache_hosts,
    $cache_prefix,
    $broker_url,
    $solitude_proxy,
    $sentry_dsn,
    $paypal_url_whitelist,
    $aes_key_dir,
    $statsd_host,
    $statsd_port,
    $lb_name = 'solitude-prod'
) {

    $web_server_type = 'web'

    file {
        $aes_key_dir:
            ensure => 'directory';

        [$project_dir,
         "${project_dir}/settings",
         "${project_dir}/settings/sites",
         "${project_dir}/settings/sites/${site}"]:
            ensure => 'directory';

        "${project_dir}/fabfile.py":
            content => template('solitude/fabfile.py');

        "${project_dir}/settings/local.py":
            content => template('solitude/settings/local.py');

        "${project_dir}/settings/sites/${site}/private_base.py":
            content => template('solitude/settings/private.py');
    }
}
