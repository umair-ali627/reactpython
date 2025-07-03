#!/bin/bash
set -e  # exit on any error

if [ "${DEV:-false}" = "true" ]; then
  echo "🚀 Running in DEV mode with Flask"
  exec poetry run flask run --host 0.0.0.0 --port 8080
else
  echo "🚀 Running in PROD mode with uWSGI"
  exec poetry run uwsgi -s /tmp/uwsgi.sock \
                        --manage-script-name \
                        --mount /=src/entry.py \
                        --callable flask_app \
                        --http 0.0.0.0:8080
fi
