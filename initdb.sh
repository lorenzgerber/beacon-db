#!/bin/bash
set -e
echo "Creating user and database"
psql -U postgres -h localhost <<-EOSQL
    CREATE USER microaccounts_dev WITH PASSWORD 'r783qjkldDsiu';
    CREATE DATABASE elixir_beacon_dev;
    CREATE DATABASE elixir_beacon_testing;
    GRANT ALL PRIVILEGES ON DATABASE elixir_beacon_dev TO microaccounts_dev;
    GRANT ALL PRIVILEGES ON DATABASE elixir_beacon_testing TO microaccounts_dev;
EOSQL

echo "Creating DB schema"
PGPASSWORD=r783qjkldDsiu \
    psql -U microaccounts_dev -h localhost -d elixir_beacon_dev < /tmp/elixir_beacon_db_schema.sql
    psql -U microaccounts_dev -h localhost -d elixir_beacon_deb < /tmp/elixir_beacon_function.sql
    psql -U microaccounts_dev -h localhost -d elixir_beacon_testing < /tmp/elixir_beacon_db_schema.sql
    psql -U microsccounts_dev -h localhost -d elixir_beacon_testing < /tmp/elixir_beacon_function.sql

