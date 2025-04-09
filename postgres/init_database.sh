#!/bin/bash
set -e

# Debug print to verify variable value at runtime
echo "Using D11DBUSER_PASSWORD: $D11DBUSER_PASSWORD"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<EOSQL
    CREATE USER d11dbuser WITH PASSWORD '$D11DBUSER_PASSWORD' CREATEDB;

    CREATE DATABASE d11;
    GRANT ALL PRIVILEGES ON DATABASE d11 TO d11dbuser;

    CREATE DATABASE d11_dev;
    GRANT ALL PRIVILEGES ON DATABASE d11_dev TO d11dbuser;
EOSQL

for db in d11 d11_dev; do
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname="$db" <<EOSQL
    GRANT USAGE, CREATE ON SCHEMA public TO d11dbuser;
    ALTER SCHEMA public OWNER TO d11dbuser;
EOSQL
done
