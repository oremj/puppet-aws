# This is an example settings/local.py file.
# These settings overrides what's in settings/base.py

# To extend any settings from settings/base.py here's an example:
import dj_database_url
from . import base

SERVER_EMAIL = '<%= server_email %>'
EMAIL_HOST = '<%= email_host %>'

DATABASES = {
    'default': dj_database_url.parse('<%= db_url %>'),
    'slave': dj_database_url.parse('<%= db_url_slave %>')
}

DATABASES['default'].update({
    'OPTIONS': {
        'init_command': 'SET storage_engine=InnoDB',
        'charset': 'utf8',
        'use_unicode': True,
    },
    'TEST_CHARSET': 'utf8',
    'TEST_COLLATION': 'utf8_general_ci',
})

DATABASES['slave'].update({
    'OPTIONS': {
        'init_command': 'SET storage_engine=InnoDB',
        'charset': 'utf8',
        'use_unicode': True,
    },
})

# Uncomment this and set to all slave DBs in use on the site.
SLAVE_DATABASES = ['slave']

CACHE_PREFIX = '<% cache_prefix %>'

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '<%= memcache_hosts %>'.split(';'),
        'TIMEOUT': 500,
        'KEY_PREFIX': CACHE_PREFIX,
    },
}

# Recipients of traceback emails and other notifications.
ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)
MANAGERS = ADMINS

# Debugging displays nice error messages, but leaks memory. Set this to False
# on all server instances and True only for development.
DEBUG = TEMPLATE_DEBUG = True

# Is this a development instance? Set this to True on development/master
# instances and False on stage/prod.
DEV = True

# Set up bcrypt.
HMAC_KEYS = {
    '2011-01-01': 'cheesecake',
}
from django_sha2 import get_password_hashers
PASSWORD_HASHERS = get_password_hashers(base.BASE_PASSWORD_HASHERS, HMAC_KEYS)

# Make this unique, and don't share it with anybody.  It cannot be blank.
SECRET_KEY = '<%= secret_key %>'

# Uncomment these to activate and customize Celery:
CELERY_ALWAYS_EAGER = False  # required to activate celeryd
BROKER_URL = '<%= broker_url %>'

CELERY_RESULT_BACKEND = 'database'
CELERY_RESULT_DBURI = '<%= db_url %>'

SYSLOG_TAG = 'http_app_<%= cache_prefix %>'

CLEANSED_SETTINGS_ACCESS = True

PAYPAL_PROXY = '<%= solitude_proxy %>/proxy/paypal/'

SENTRY_DSN = '<%= sentry_dsn %>'

PAYPAL_LIMIT_PREAPPROVAL = False
PAYPAL_URL_WHITELIST = ('<%= paypal_url_whitelist %>',)

AES_KEYS = {
    'buyerpaypal:key': '<%= aes_key_dir %>/buyerpaypal.key',
    'sellerbluevia:id': '<%= aes_key_dir %>/sellerbluevia.key',
    'sellerpaypal:id': '<%= aes_key_dir %>/sellerpaypal_id.key',
    'sellerpaypal:token': '<%= aes_key_dir %>/sellerpaypal_token.key',
    'sellerpaypal:secret': '<%= aes_key_dir %>/sellerpaypal_secret.key',
    'sellerproduct:secret': '<%= aes_key_dir %>/sellerproduct_secret.key',
}

## Log settings

# SYSLOG_TAG = "http_app_playdoh"  # Make this unique to your project.
# LOGGING = dict(loggers=dict(playdoh={'level': logging.DEBUG}))

# Common Event Format logging parameters
#CEF_PRODUCT = 'Playdoh'
#CEF_VENDOR = 'Mozilla'
HAS_SYSLOG = False
