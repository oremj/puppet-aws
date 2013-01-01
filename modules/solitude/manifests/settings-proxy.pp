define solitude::settings-proxy(
    $project_dir,
    $secret_key,
    $server_email,
    $email_host,
    $cache_prefix,
    $sentry_dsn,
    $paypal_url_whitelist,
    $paypal_app_id,
    $paypal_auth_user,
    $paypal_auth_password,
    $paypal_auth_signature,
    $aes_key_dir
) {

    file {
        "${project_dir}/settings":
            ensure => 'directory';

        "${project_dir}/settings/local.py":
            content => template('solitude/settings/local-proxy.py');
    }
}
