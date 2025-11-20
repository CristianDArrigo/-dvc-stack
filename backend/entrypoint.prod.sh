#!/bin/sh
set -e

echo "Running database migrations..."
python manage.py migrate --noinput

echo "Creating superuser if not exists..."
python manage.py createsuperuser \
  --noinput \
  --username "$DJANGO_SUPERUSER_USERNAME" \
  --email "$DJANGO_SUPERUSER_EMAIL" || true

echo "Starting Gunicorn server..."
exec "$@"
