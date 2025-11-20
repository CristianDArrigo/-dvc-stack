#!/bin/sh
set -e

echo "Creating migrations and applying them..."
# Tenta le migrazioni più volte in caso di errori transitori
RETRIES=10
for i in $(seq 1 $RETRIES); do
  echo "Attempt $i/$RETRIES..."
  if python manage.py makemigrations && python manage.py migrate --noinput; then
    echo "Migrations created and applied successfully"
    break
  fi
  echo "Migration attempt $i/$RETRIES failed, retrying in 3s..."
  sleep 3
done

echo "Migrations completed."

echo "Creating superuser if not exists..."
python manage.py createsuperuser \
  --noinput \
  --username "$DJANGO_SUPERUSER_USERNAME" \
  --email "$DJANGO_SUPERUSER_EMAIL" || true
echo "Superuser creation attempted."

echo "Starting Django server..."
exec "$@"
