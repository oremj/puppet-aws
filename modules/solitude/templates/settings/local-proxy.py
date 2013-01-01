SERVER_EMAIL = '<%= server_email %>'
EMAIL_HOST = '<%= email_host %>'
DATABASES = {'default': {}}

ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)
MANAGERS = ADMINS

DEBUG = TEMPLATE_DEBUG = False

DEV = True

HMAC_KEYS = {  # for bcrypt only
    '2011-01-01': 'cheesecake',
}


SECRET_KEY = '<%= secret_key %>'

SYSLOG_TAG = 'http_app_<%= cache_prefix %>'

PAYPAL_APP_ID = '<%= paypal_app_id %>'
PAYPAL_CHAINS = (
    (30, '<%= paypal_chains %>'),
)
PAYPAL_AUTH = {
    'USER': '<%= paypal_auth_user %>',
    'PASSWORD': '<%= paypal_auth_password %>',
    'SIGNATURE': '<%= paypal_auth_signature %>',
}
PAYPAL_USE_SANDBOX = True
PAYPAL_LIMIT_PREAPPROVAL = False

CLEANSED_SETTINGS_ACCESS = True

SENTRY_DSN = '<%= sentry_dsn %>'

AES_KEYS = {}
