define solitude::settings(
    $project_dir,
    $db_url,
    $secret_key,
    $server_email,
    $email_host,
    $memcache_hosts,
    $cache_prefix,
    $broker_url,
    $solitude_proxy,
    $sentry_dsn,
    $paypal_url_whitelist,
    $aes_key_dir
) {

    file {
        $aes_key_dir:
            ensure => 'directory';

        "${project_dir}/settings":
            ensure => 'directory';

        "${project_dir}/settings/local.py":
            content => template('solitude/settings/local.py');
    }
}
