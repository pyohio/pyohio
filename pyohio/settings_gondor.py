import os
import urlparse

from .settings import *

DEBUG = {"dev": True}.get(os.environ["GONDOR_INSTANCE"], False)

if "GONDOR_DATABASE_URL" in os.environ:
    urlparse.uses_netloc.append("postgres")
    url = urlparse.urlparse(os.environ["GONDOR_DATABASE_URL"])
    DATABASES = {
        "default": {
            "ENGINE": {
                "postgres": "django.db.backends.postgresql_psycopg2"
            }[url.scheme],
            "NAME": url.path[1:],
            "USER": url.username,
            "PASSWORD": url.password,
            "HOST": url.hostname,
            "PORT": url.port
        }
    }

if "GONDOR_REDIS_URL" in os.environ:
    urlparse.uses_netloc.append("redis")
    url = urlparse.urlparse(os.environ["GONDOR_REDIS_URL"])
    CACHES = {
        "default": {
            "BACKEND": "redis_cache.RedisCache",
            "LOCATION": "%s:%s" % (url.hostname, url.port),
            "OPTIONS": {
                "DB": 0,
                "PASSWORD": url.password,
                "PARSER_CLASS": "redis.connection.HiredisParser"
            },
        },
    }

SITE_ID = int(os.environ.get("SITE_ID", "1"))

MEDIA_ROOT = os.path.join(os.environ["GONDOR_DATA_DIR"], "site_media", "media")
STATIC_ROOT = os.path.join(os.environ["GONDOR_DATA_DIR"], "site_media", "static")

MEDIA_URL = "/site_media/media/"  # make sure this maps inside of site_media_url
STATIC_URL = "/site_media/static/"  # make sure this maps inside of site_media_url
ADMIN_MEDIA_PREFIX = STATIC_URL + "admin/"

FILE_UPLOAD_PERMISSIONS = 0640

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "simple": {
            "format": "%(levelname)s %(message)s"
        },
    },
    "handlers": {
        "console": {
            "level": "DEBUG",
            "class": "logging.StreamHandler",
            "formatter": "simple"
        }
    },
    "root": {
        "handlers": ["console"],
        "level": "INFO",
    },
    "loggers": {
        "django.request": {
            "propagate": True,
        },
    }
}

DEFAULT_FROM_EMAIL = "PyOhio 2013 <no-reply@pyohio.org>"

if "GONDOR_SENDGRID_USER" in os.environ:
    EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
    EMAIL_HOST = "smtp.sendgrid.net"
    EMAIL_PORT = 587
    EMAIL_HOST_USER = os.environ["GONDOR_SENDGRID_USER"]
    EMAIL_HOST_PASSWORD = os.environ["GONDOR_SENDGRID_PASSWORD"]
    EMAIL_USE_TLS = True
