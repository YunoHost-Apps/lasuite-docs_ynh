# See https://github.com/suitenumerique/docs/blob/d95281593276ce17cd72779b61433fc0b002e35c/docker/files/usr/local/etc/gunicorn/impress.py for the list of variables

# Gunicorn-django settings
bind = ["127.0.0.1:__PORT_BACKEND__"]
name = "docs"
python_path = "__INSTALL_DIR__/src/backend"

# Run
graceful_timeout = 90
timeout = 90
workers = 3

# Logging
# Using '-' for the access log file makes gunicorn log accesses to stdout
accesslog = "-"
# Using '-' for the error log file makes gunicorn log errors to stderr
errorlog = "-"
loglevel = "info"
