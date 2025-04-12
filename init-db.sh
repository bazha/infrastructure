#!/bin/bash
set -e

echo "Starting init-db.sh with POSTGRES_USER=$POSTGRES_USER"
echo "POSTGRES_MULTIPLE_DATABASES=$POSTGRES_MULTIPLE_DATABASES"

if [ -z "$POSTGRES_PASSWORD" ]; then
  echo "Error: POSTGRES_PASSWORD is not set"
  exit 1
fi

echo "PostgreSQL is ready"

if [ -z "$POSTGRES_MULTIPLE_DATABASES" ]; then
  echo "Error: POSTGRES_MULTIPLE_DATABASES is not set. No databases will be created."
  exit 1
fi

IFS=',' read -ra DB_LIST <<< "$POSTGRES_MULTIPLE_DATABASES"

for db in "${DB_LIST[@]}"; do
  db=$(echo "$db" | xargs)
  if [ -z "$db" ]; then
    echo "Warning: Empty database name found, skipping..."
    continue
  fi
  echo "Checking/creating database: $db"
  psql -U "$POSTGRES_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$db'" | grep -q 1 || \
    psql -U "$POSTGRES_USER" -d postgres -c "CREATE DATABASE \"$db\";"
done

echo "Database initialization completed."